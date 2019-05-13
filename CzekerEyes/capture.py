import cv2
import numpy as np
from matplotlib import pyplot as plt
import os
import time

GOOD_MATCH_RATIO = 0.1

def show_webcam(mirror=False):
    cam = cv2.VideoCapture(0)
    img_counter = 0
    while True:
        ret_val, frame = cam.read()
        if mirror:
            img = cv2.flip(frame, 1)
        cv2.imshow('my webcam', frame)

        k = cv2.waitKey(1)
        if k == 27:
            break  # esc to quit
        elif k == 32:
            # Spacebar pressed
            img_name = 'opencv_frame_{}.png'.format(img_counter)
            cv2.imwrite(img_name, frame)
            print("{} written!".format(img_name))
            img_counter += 1

    cv2.destroyAllWindows()

def plot_test_images(img):
    alphabet = cv2.imread(img)

    alphabetBlur = cv2.cvtColor(alphabet, cv2.COLOR_RGB2GRAY)
    alphabetBlur = cv2.medianBlur(alphabetBlur, 15)

    th1 = cv2.adaptiveThreshold(alphabetBlur, 255, cv2.ADAPTIVE_THRESH_GAUSSIAN_C, cv2.THRESH_BINARY, 21, 11)
    th1 = cv2.bitwise_not(th1)

    kernel = np.ones((5, 5), np.uint8)
    dilation1 = cv2.dilate(th1, kernel, iterations=1)
    closing1 = cv2.morphologyEx(dilation1, cv2.MORPH_CLOSE, kernel)
    edges1 = cv2.Canny(alphabetBlur, 180, 220)

    titles = ['Alphabet', 'Alphabet threshold', 'Alphabet after dilation and closing', 'Alphabet edges']
    images = [alphabet, th1, closing1, edges1]

    plt.figure(dpi=300)
    for i in range(4):
        plt.subplot(2, 2, i + 1), plt.imshow(images[i], 'gray')
        plt.title(titles[i])
        plt.xticks([]), plt.yticks([])
    plt.show()

    cv2.waitKey()
    cv2.destroyAllWindows()
    return images

def board_detection_ORB(testImg):
    refImg = cv2.imread('test_img/reference2.jpg', 0)
    cv2.imshow('reference', refImg)

    orb = cv2.ORB_create(500)
    testImg = cv2.resize(testImg, None, fx=0.4, fy=0.4, interpolation=cv2.INTER_AREA)
    refImg = cv2.resize(refImg, None, fx=0.4, fy=0.4, interpolation=cv2.INTER_AREA)

    kp = orb.detect(refImg, None)
    kp1, des1 = orb.detectAndCompute(refImg, None)
    kp2, des2 = orb.detectAndCompute(testImg, None)

    bf = cv2.BFMatcher(cv2.NORM_HAMMING, crossCheck=True)

    matches = bf.match(des1, des2)
    matches = sorted(matches, key=lambda x: x.distance)

    for m in matches:
        print(m.distance)

    plt.figure(dpi=500)
    result = np.zeros((1000, 1000, 3), np.uint8)
    result = cv2.drawMatches(refImg, kp1, testImg, kp2, matches[:int(len(matches) * 0.5)], result)

    plt.imshow(result), plt.show()

def board_detection_BRISK(testImg):

    # Load and resize images
    refImg = cv2.imread('test_img/reference2.jpg', 0)
    colorTestImg = cv2.cvtColor(testImg, cv2.COLOR_RGB2BGR)
    testImg = cv2.cvtColor(testImg, cv2.COLOR_RGB2GRAY)

    if(testImg.size > 307200):
        testImg = cv2.resize(testImg, None, fx=0.3, fy=0.3, interpolation=cv2.INTER_AREA)
        colorTestImg = cv2.resize(colorTestImg, None, fx=0.3, fy=0.3, interpolation=cv2.INTER_AREA)
    refImg = cv2.resize(refImg, None, fx=0.3, fy=0.3, interpolation=cv2.INTER_AREA)

    # Create BRISK, detect keypoints and descriptions
    brisk = cv2.BRISK_create(40)
    kp1, des1 = brisk.detectAndCompute(refImg, None)
    kp2, des2 = brisk.detectAndCompute(testImg, None)

    # Create BFMatcher and knnMatch descriptions
    bf = cv2.BFMatcher()
    matches = bf.knnMatch(des1, des2, k=2)

    # Filter for only close enough matches
    good = []
    for m, n in matches:
        if m.distance < 0.65 * n.distance:
            good.append(m)

    # If there is enough matches warp the board, draw grid, find tiles and plot results
    if len(good)>10:
        src_pts = np.float32([kp1[m.queryIdx].pt for m in good]).reshape(-1,1,2)
        dst_pts = np.float32([kp2[m.trainIdx].pt for m in good]).reshape(-1, 1, 2)

        M, mask = cv2.findHomography(src_pts, dst_pts, cv2.RANSAC, 5.0)
        matchesMask = mask.ravel().tolist()

        h,w = refImg.shape
        pts = np.float32([[0,0],[0,h-1],[w-1,h-1],[w-1,0]]).reshape(-1,1,2)
        dst = cv2.perspectiveTransform(pts,M)

        pts2 = np.float32([[0,0],[w-1,0],[0,h-1],[w-1,h-1]]).reshape(-1,1,2)
        dst2 = cv2.perspectiveTransform(pts2,M)

        img2 = cv2.polylines(testImg, [np.int32(dst)],True,255,3,cv2.LINE_AA)

        draw_params = dict(matchColor = (0,255,0),
                           singlePointColor = None,
                           matchesMask = matchesMask,
                           flags = 2)


        board_size = np.float32([[0,0],[600,0],[0,600],[600,600]])
        matrix = cv2.getPerspectiveTransform(dst2, board_size)

        warpped_board = cv2.warpPerspective(colorTestImg, matrix, (600,600))
        detect_tiles(warpped_board)
        warpped_board = draw_grid(warpped_board)
        warpped_board = cv2.cvtColor(warpped_board, cv2.COLOR_RGB2BGR)

        img3 = cv2.drawMatches(refImg, kp1, img2, kp2, good, None, **draw_params)

        plt.figure(dpi=450)
        plt.subplot(2,1,1), plt.imshow(warpped_board, 'gray'), plt.title('Warpped board'), plt.axis('off')
        plt.subplot(2,1,2), plt.imshow(img3, 'gray'), plt.title('Matching'), plt.axis('off')
        plt.show()
    else:
        print('Not enough matches found!')
        matchesMask = None

    # # Plot results
    # plt.figure(dpi=450)
    # result = np.zeros((1000,1000,3), np.uint8)
    # result = cv2.drawMatchesKnn(refImg, kp1, testImg, kp2, good, result)
    # plt.imshow(result), plt.show()


def draw_grid(refImg):
    refImg = cv2.cvtColor(refImg, cv2.COLOR_RGB2BGR)
    h, w, r = refImg.shape
    print(h,w,r)

    # h1 = 4
    # w1 = 4
    # tile = refImg[20+35*h1:20+35*(h1+1), 55+34*w1:55+34*(w1+1)]
    # print(tile.shape)

    for i in range(0,16):
        widthDist = int((w-50)/16*i)
        heightDist = int((h-35)/16*i)
        print('widthDist', widthDist, 'heightDist', heightDist)
        # vertical
        cv2.line(refImg, (45 + widthDist , 20), (45 + widthDist, h-50), (0, 255, 0), 2, 1)
        # horizontal
        cv2.line(refImg, (45, 20 + heightDist), (w-40, 20 + heightDist), (0, 255, 0), 2, 1)

    return refImg

def detect_tiles(refImg):
    refImg = cv2.cvtColor(refImg, cv2.COLOR_RGB2BGR)
    tiles = []

    for h in range(0, 14):
        for w in range(0, 14):
            tile = refImg[20 + 35 * h:20 + 35 * (h + 1), 50 + 34 * w:50 + 34 * (w + 1)]
            hisB = cv2.calcHist([tile], [0], None, [256], [0, 256])
            hisG = cv2.calcHist([tile], [1], None, [256], [0, 256])
            hisR = cv2.calcHist([tile], [2], None, [256], [0, 256])
            if (hisR[255] > 600 and hisG[225] > 10 and hisB[255] < 50):
                # cv2.imshow('{}, {}'.format(h,w), tile)
                tiles.append(tile)

    # for i in range(0, tiles.__len__()):
    #     cv2.imshow('{}'.format(i), tiles[i])

    return tiles

def main():
    # show_webcam()
    # testImg = cv2.imread('test_img/one_place.jpg', 0)
    testImg = cv2.imread('opencv_frame_1.png', 1)
    board_detection_BRISK(testImg)


if __name__ == '__main__':
    main()
