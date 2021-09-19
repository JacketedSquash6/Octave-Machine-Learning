
f1 = 1 - (imread("sample_images/face1.bmp")/255);
f2 = 1 - (imread("sample_images/face2.bmp")/255);
f3 = 1 - (imread("sample_images/face3.bmp")/255);
f4 = 1 - (imread("sample_images/face4.bmp")/255);
f5 = 1 - (imread("sample_images/face5.bmp")/255);
f6 = 1 - (imread("sample_images/face6.bmp")/255);
sampleFaces = [f1; f2; f3; f4; f5; f6];

##Emoji Structure:

# r r r @ @ @ @ r r r
# r @ @         @ @ r
# r @             @ r
# @   i i     i i   @
# @   i i     i i   @
# @                 @
# @     m m m m     @
# r @   m m m m   @ r
# r @ @         @ @ r
# r r r @ @ @ @ r r r

# 'r' should be random noise
# '@' is black (1)
# ' ' is white (0)
# 'i' samples an eye from a random face image
# 'm' samples a mouth from a (possibly different) random face image

structure = [
9 9 9 1 1 1 1 9 9 9;
9 1 1 0 0 0 0 1 1 9;
9 1 0 0 0 0 0 0 1 9;
1 0 3 3 0 0 3 3 0 1;
1 0 3 3 0 0 3 3 0 1;
1 0 0 0 0 0 0 0 0 1;
1 0 0 4 4 4 4 0 0 1;
9 1 0 4 4 4 4 0 1 9;
9 1 1 0 0 0 0 1 1 9;
9 9 9 1 1 1 1 9 9 9
];

data = zeros(3600, 100);

for s = 1:3600
  emoji = rand(10, 10);
  rEye = randi([0, 5]);
  rMouth = randi([0, 5]);
   
  for i = 1:10
    for j = 1:10
      if structure(i, j) == 0
        emoji(i, j) = 0;
      endif;
      if structure(i, j) == 1
        emoji(i, j) = 1;
      endif;
      if structure(i, j) == 3
        emoji(i, j) = sampleFaces(i + (10*rEye), j);
      endif;
      if structure(i, j) == 4
        emoji(i, j) = sampleFaces(i + (10*rMouth), j);
      endif;
    endfor;
  endfor;
  
  emoji = emoji(:);
  data(s, :) = emoji;
endfor;

csvwrite("data.csv", data);