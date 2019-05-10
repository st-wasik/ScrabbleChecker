import cv2
import numpy as np
from matplotlib import pyplot as plt
import os
import time

GOOD_MATCH_RATIO = 0.1

def show_webcam(mirror=False):
    cam = cv2.VideoCapture(0)
    while True:
        ret_val, img = cam.read()
        if mirror:
            img = cv2.flip(img, 1)
        cv2.imshow('my webcam', img)
        if cv2.waitKey(1) == 27:
            break  # esc to quit
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


index = 0


def matcher(imgSet, imgLetter):
    outimg = []

    for file in imgLetter:
        imagesLetter = plot_test_images(file)[2]
        imagesSet = plot_test_images(imgSet)[2]

        orb = cv2.ORB_create()

        kp1, des1 = orb.detectAndCompute(imagesSet, None)
        kp2, des2 = orb.detectAndCompute(imagesLetter, None)

        bf = cv2.BFMatcher(cv2.NORM_HAMMING, crossCheck=True)

        # Match descriptors.
        matches = bf.match(des1, des2)

        # Sort them in the order of their distance.
        matches = sorted(matches, key=lambda x: x.distance)

        # Draw first 10 matches.
        img3 = True
        outimg.append(cv2.drawMatches(imagesSet, kp1, imagesLetter, kp2, matches[:10], flags=2, outImg=img3))

    def toggle_images(event):
        global index

        if event.key == 'right':
            index += 1
        else:
            index -= 1

        if index < len(outimg):
            plt.imshow(outimg[index])
            plt.draw()
        else:
            plt.close()

    plt.imshow(outimg[index])

    plt.connect('key_press_event', toggle_images)
    plt.show()


def template_match(imgTmp, imgFin):
    img = plot_test_images(imgTmp)[2]
    img2 = img.copy()
    template = plot_test_images(imgFin)[2]
    w, h = template.shape[::-1]

    methods = ['cv2.TM_CCOEFF', 'cv2.TM_CCOEFF_NORMED',
               'cv2.TM_CCORR_NORMED', 'cv2.TM_SQDIFF', 'cv2.TM_SQDIFF_NORMED']

    for meth in methods:

        img = img2.copy()
        method = eval(meth)

        res = cv2.matchTemplate(img, template, method)
        min_val, max_val, min_loc, max_loc = cv2.minMaxLoc(res)

        if method in [cv2.TM_SQDIFF, cv2.TM_SQDIFF_NORMED]:
            top_left = min_loc
        else:
            top_left = max_loc

        bottom_right = (top_left[0] + w, top_left[1] + h)
        cv2.rectangle(img, top_left, bottom_right, 255, 50)
        plt.subplot(121), plt.imshow(template, cmap='gray')
        plt.title('What detection'), plt.xticks([]), plt.yticks([])
        plt.subplot(122), plt.imshow(img, cmap='gray')
        plt.title('Detected Point'), plt.xticks([]), plt.yticks([])
        plt.suptitle(meth)
        plt.show(block=False)
        plt.pause(1)
        plt.close()


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
    testImg = cv2.resize(testImg, None, fx=0.3, fy=0.3, interpolation=cv2.INTER_AREA)
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
            good.append([m])

    # Plot results
    plt.figure(dpi=450)
    result = np.zeros((1000,1000,3), np.uint8)
    result = cv2.drawMatchesKnn(refImg, kp1, testImg, kp2, good, result)
    plt.imshow(result), plt.show()


def main():
    # show_webcam(mirror=True)
    # files = []
    # for file in os.listdir('test_img/alfabet_close'):
    #     files.append('test_img/alfabet_close/' + file)
    #
    # for file in files:
    #     template_match('test_img/alfabet_close.jpg', file)

    testImg = cv2.imread('test_img/one_place.jpg', 0)
    board_detection_BRISK(testImg)
    # board_detection_ORB(testImg)


if __name__ == '__main__':
    main()
