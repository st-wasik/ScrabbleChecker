from matplotlib import pyplot as plt
from capture import plot_test_images
from capture import show_webcam
from PIL import Image
import pytesseract
import cv2
import os
import json
import re

def tesseract_recognition(name, thresh=False, blur=False, ):
    print (name)
    #for i in range(0,8):
    # load the example image and convert it to grayscale
    image = cv2.imread(name)
    gray = cv2.cvtColor(image, cv2.COLOR_BGR2GRAY)

    # check to see if we should apply thresholding to preprocess the
    # image
    if thresh:
        gray = cv2.threshold(gray, 0, 255,
                             cv2.THRESH_BINARY | cv2.THRESH_OTSU)[1]

    # make a check to see if median blurring should be done to remove
    # noise

    if blur:
        gray = cv2.medianBlur(gray, 3)

    # write the grayscale image to disk as a temporary file so we can
    # apply OCR to it
    filename = "{}.png".format(os.getpid())
    cv2.imwrite(filename, gray)

    # load the image as a PIL/Pillow image, apply OCR, and then delete
    # the temporary file
    pytesseract.pytesseract.tesseract_cmd = r'D:\Programy\Tesseract-OCR\tesseract.exe'
    text = pytesseract.image_to_string(Image.open(filename), lang="pol", config="-c tessedit_char_whitelist=AĄBCĆDEĘFGHIJKLŁMNŃOÓPRSŚTUWYZŹŻ --psm 10")
    os.remove(filename)
    # print("lol")
    print(text)

    # show the output images
    cv2.imshow("Image", image)
    cv2.imshow("Output", gray)
    cv2.waitKey(0)




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



def template_match_json(imgTmp, imgFin):
    img = cv2.imread(imgTmp,0)
    img2 = img.copy()
    template = cv2.imread(imgFin,0)
    w, h = template.shape[::-1]

    methods = ['cv2.TM_CCOEFF_NORMED', 'cv2.TM_CCORR_NORMED', 'cv2.TM_SQDIFF', 'cv2.TM_SQDIFF_NORMED']
    # index = 1
    avg_top = [0,0]
    avg_bottom = [0,0]
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

        avg_top[0] += top_left[0]
        avg_top[1] += top_left[1]

        avg_bottom[0] += bottom_right[0]
        avg_bottom[1] += bottom_right[1]

        # cv2.rectangle(img, top_left, bottom_right, 0, 5)
        # plt.subplot(121), plt.imshow(template, cmap='gray')
        # plt.title('What detection'+ str(index)), plt.xticks([]), plt.yticks([])
        # plt.subplot(122), plt.imshow(img, cmap='gray')
        # plt.title('Detected Point'), plt.xticks([]), plt.yticks([])
        # plt.suptitle(meth)
        # plt.show()
        # #plt.pause(10)
        # #plt.close()
        # index +=1
    avg_top[0] = avg_top[0]/4
    avg_top[1] = avg_top[1]/4
    avg_bottom[0] = avg_bottom[0]/4
    avg_bottom[1] = avg_bottom[1]/4
    return avg_top, avg_bottom


def switch(x):
    return {
        'aa': 'ą',
        'cc':'ć',
        'ee':'ę',
        'll':'ł',
        'nn':'ń',
        'oo':'ó',
        'ss':'ś',
        'zz':'ź',
        'zzz':'ż'
    }.get(x, x)




def template_match(imgTmp, imgFin):
    img = cv2.imread(imgTmp,0)
    img2 = img.copy()
    template = cv2.imread(imgFin,0)
    w, h = template.shape[::-1]

    methods = ['cv2.TM_CCOEFF_NORMED', 'cv2.TM_CCORR_NORMED', 'cv2.TM_SQDIFF', 'cv2.TM_SQDIFF_NORMED']
    # index = 1
    avg_top = [0, 0]
    avg_bottom = [0, 0]
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

        avg_top[0] += top_left[0]
        avg_top[1] += top_left[1]

        avg_bottom[0] += bottom_right[0]
        avg_bottom[1] += bottom_right[1]

        # cv2.rectangle(img, top_left, bottom_right, 0, 5)
        # plt.subplot(121), plt.imshow(template, cmap='gray')
        # plt.title('What detection'+ str(index)), plt.xticks([]), plt.yticks([])
        # plt.subplot(122), plt.imshow(img, cmap='gray')
        # plt.title('Detected Point'), plt.xticks([]), plt.yticks([])
        # plt.suptitle(meth)
        # plt.show()
        # #plt.pause(10)
        # #plt.close()
        # index +=1
    avg_top[0] = avg_top[0] / 4
    avg_top[1] = avg_top[1] / 4
    avg_bottom[0] = avg_bottom[0] / 4
    avg_bottom[1] = avg_bottom[1] / 4
    f = open("letters.json", 'r')
    letters_json = json.loads(f.read())
    for letter, cords in letters_json.items():
        # print(cords, [avg_top, avg_bottom])
        if cords == [avg_top, avg_bottom]:
            return switch(letter)
        else:
            print(letter, "NOPE")
            return " "

def contures():
    img = cv2.imread('test_img/alfabet.jpg', 0)

    ret, thresh = cv2.threshold(img, 127, 255, 0)

    contours, hierarchy = cv2.findContours(thresh, 1, 2)

    cv2.drawContours(img, contours, -1, (255, 255, 255), 10)

    plt.imshow(img)
    plt.show()

    cnt = contours[0]

    M = cv2.moments(cnt)

def create_json():
    files = []
    folder = "test_img/letters/"
    refrence = "test_img/board.png"
    regex = re.compile(r'/\w+\.')
    for file in os.listdir(folder):
        files.append(folder + file)
    letters_json = {}
    for file in files:
        match = re.search(regex,file)
        if match:
            name = match.group(0)[1:-1]
        else:
            print("FUCK")
        tmp = template_match_json(refrence, file)
        letters_json[name] = tmp
    x = json.dumps(letters_json)
    f = open("letters.json", 'w')
    f.write(x)

def main():
    # #show_webcam(mirror=True)
    files = []
    folder = "test_img/letters/"
    refrence = "test_img/board.png"
    for file in os.listdir(folder):
        files.append(folder + file)
        # tesseract_recognition(folder + file)

    test = ""
    for file in files:
        test += template_match(refrence, file)
    print(test)
    # create_json()

if __name__ == '__main__':
    main()
