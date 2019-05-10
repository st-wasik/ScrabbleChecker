import cv2
import numpy as np
from matplotlib import pyplot as plt
from capture import plot_test_images
from capture import show_webcam
import os

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


def main():
    show_webcam(mirror=True)
    files = []
    for file in os.listdir('test_img/alfabet_close'):
        files.append('test_img/alfabet_close/' + file)

    for file in files:
        template_match('test_img/alfabet_close.jpg', file)


if __name__ == '__main__':
    main()
