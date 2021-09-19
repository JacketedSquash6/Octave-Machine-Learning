[fakeData, Gaz] = generateImages(GT, GT_DIMS, 3600);
##data = csvread("data.csv");
##data = realData;
data = fakeData;

faceArray = [];
for i = 1:10
  faceRow = [];
  for j = 1:10
    idx = randi(3599);
    face = reshape(data(idx, :), 10, 10);
    faceRow = [faceRow face];
  endfor;
  faceArray = [faceArray; faceRow];
endfor;

size(data)
imshow(1-faceArray);