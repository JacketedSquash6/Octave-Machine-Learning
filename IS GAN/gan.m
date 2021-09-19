realData = csvread("data.csv");
numSamples = size(realData, 1);

### Network Structure

##Generator
# m x 10 noise input layer
# GenTheta1 11 x 30
# Leaky ReLu
# m x 30 hidden layer
# GenTheta2 31 x 100
# Sigmoid
# m x 100 generated images

##Discriminator
# m x 100 image input
# DiscTheta1 101 x 30
# Leaky ReLu
# m x 30 hidden layer
# DiscTheta2 31 x 10
# Leaky ReLu
# m x 10 hidden layer
# DiscTheta3 11 x 1
# Sigmoid
# m x 1 predictions

GT_DIMS = [30, 11; 100, 31]; #dimensions of Generator Theta matrices
DT_DIMS = [30, 101; 10, 31; 1, 11]; #dimensions of Discriminator Theta matrices

GenTheta1 = rand(GT_DIMS(1,1), GT_DIMS(1,2)) - 0.5;
GenTheta2 = rand(GT_DIMS(2,1), GT_DIMS(2,2)) - 0.5;
GT = [GenTheta1(:); GenTheta2(:)]; #unroll Generator values into a vecotr

DiscTheta1 = rand(DT_DIMS(1,1), DT_DIMS(1,2)) - 0.5;
DiscTheta2 = rand(DT_DIMS(2,1), DT_DIMS(2,2)) - 0.5;
DiscTheta3 = rand(DT_DIMS(3,1), DT_DIMS(3,2)) - 0.5;
DT = [DiscTheta1(:); DiscTheta2(:); DiscTheta3(:)]; #Discriminator Theta


dLossLog = []; #keep track of loss to plot it later
gLossLog = [];

EPOCHS = 10000;
learnRate = 0.1;

fakePictureLog = []; #we will save some images after every couple epochs to monitor progress

for i = 1:EPOCHS
  #todo minibatches if I feel like it
  
  #Train discriminator
  [fakeData, Gaz] = generateImages(GT, GT_DIMS, numSamples);
  
  #make a labelled dataset
  X = [realData; fakeData];
  y = [ones(numSamples, 1); zeros(numSamples, 1)];
  
  #find the loss and gradients
  [j dGrad] = discriminatorCost(DT, DT_DIMS, X, y);
  dLossLog = [dLossLog; j]; #store loss
  DT = DT - learnRate*dGrad; #update Thetas
  
  
  #Train generator
  [fakeData, Gaz] = generateImages(GT, GT_DIMS, numSamples);
  #Gaz is a cell array containing the (G)enerator's (a) and (z) values
  #Gaz{1,n} is the 'a' value of the nth layer of the generator
  #Gaz{2,n} is the 'z' value of the nth layer of the generator
  
  X = fakeData;
  y = ones(numSamples, 1);
  [j gGrad] = generatorCost(GT, GT_DIMS, DT, DT_DIMS, Gaz, X, y);
  gLossLog = [gLossLog; j];
  GT = GT - learnRate*gGrad;
  
  #Save some images to look at later
  if(mod(i, 10) == 0)
    faceRow = [];
    for j = 1:10
      idx = randi(numSamples);
      face = reshape(fakeData(idx, :), 10, 10);
      faceRow = [faceRow, face];
    endfor;
    fakePictureLog = [fakePictureLog; faceRow];
  endif
  
endfor

plot([1:EPOCHS], dLossLog, '-', [1:EPOCHS], gLossLog, '-');
imwrite(1-fakePictureLog, 'fake_pics_over_time_long.bmp', 'bmp');
