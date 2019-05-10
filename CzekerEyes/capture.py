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
    testImg = cv2.imread('test_img/one_place.jpg', 0)
    board_detection_BRISK(testImg)
    # board_detection_ORB(testImg)


if __name__ == '__main__':
    main()
