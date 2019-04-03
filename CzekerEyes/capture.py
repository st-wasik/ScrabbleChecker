import cv2
import numpy as np
from matplotlib import pyplot as plt

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


def plot_test_images():
    alphabet = cv2.imread('alfabet.jpg')

    alphabetBlur = cv2.cvtColor(alphabet, cv2.COLOR_RGB2GRAY)
    alphabetBlur = cv2.medianBlur(alphabetBlur,15)

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
        plt.subplot(2,2,i+1), plt.imshow(images[i], 'gray')
        plt.title(titles[i])
        plt.xticks([]), plt.yticks([])
    plt.show()

    cv2.waitKey()
    cv2.destroyAllWindows()

def main():
    # show_webcam(mirror=True)
    plot_test_images()


if __name__ == '__main__':
    main()