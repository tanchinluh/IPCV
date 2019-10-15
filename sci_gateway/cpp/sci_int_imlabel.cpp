/***********************************************************************
 * IPCV - Scilab Image Processing and Computer Vision toolbox
 * Copyright (C) 2017  Tan Chin Luh
 ***********************************************************************/

#include "common.h"
void FindBlobs(const cv::Mat &binary, std::vector < std::vector<cv::Point2i> > &blobs);

/************************************************************
* imout = int_imlabel(imin,src,dst);
************************************************************/


int sci_int_imlabel(char * fname,void* pvApiCtx)
{

	// Initialization
	//IplImage* img_src  = NULL;

	Mat src_gray, binary;
	int thresh = 100;
	int max_thresh = 255;
	RNG rng(12345);

	// Checking numbers of Arguments
	CheckInputArgument(pvApiCtx, 1, 1);
	CheckOutputArgument(pvApiCtx, 1, 1);

	GetImage(1,binary,pvApiCtx);

	if(!binary.data) {
		std::cout << "File not found" << std::endl;
		return -1;
	}

	//Mat output = cv::Mat::zeros(binary.size(), CV_8UC3);
	//Mat output = cv::Mat::zeros(binary.size(), CV_32S);
	Mat output = cv::Mat::zeros(binary.size(), CV_64F);
	//Mat binary;
	vector < std::vector<cv::Point2i > > blobs;

	//threshold(img, binary, 0.0, 1.0, cv::THRESH_BINARY);

	FindBlobs(binary, blobs);

	// Randomy color the blobs
	for(size_t i=0; i < blobs.size(); i++) {
		/*unsigned char r = 255 * (rand()/(1.0 + RAND_MAX));
		unsigned char g = 255 * (rand()/(1.0 + RAND_MAX));
		unsigned char b = 255 * (rand()/(1.0 + RAND_MAX));*/

		for(size_t j=0; j < blobs[i].size(); j++) {
			int x = blobs[i][j].x;
			int y = blobs[i][j].y;

			/*output.at<cv::Vec3b>(y,x)[0] = b;
			output.at<cv::Vec3b>(y,x)[1] = g;
			output.at<cv::Vec3b>(y,x)[2] = r;*/
			//output.at<int>(y,x) = (int)i+1;
			output.at<double>(y, x) = (double)i + 1;
		}
	}

	//cv::imshow("binary", img);
	//cv::imshow("labelled", output);
	//cv::waitKey(0);

	// Export output image
	//IplImage* outimg = new IplImage(output); 	
	//IplImg2Mat(outimg, Rhs+1);
	//LhsVar(1) = Rhs+1;

	// Cleaning up
	//cvReleaseImage( &img_src );
	SetImage(1,output,pvApiCtx);
	return 0;

}


void FindBlobs(const cv::Mat &binary, std::vector < std::vector<cv::Point2i> > &blobs)
{
	blobs.clear();

	// Fill the label_image with the blobs
	// 0  - background
	// 1  - unlabelled foreground
	// 2+ - labelled foreground

	cv::Mat label_image;
	binary.convertTo(label_image, CV_32FC1); // weird it doesn't support CV_32S!

	int label_count = 2; // starts at 2 because 0,1 are used already

	for(int y=0; y < binary.rows; y++) {
		for(int x=0; x < binary.cols; x++) {
			if((int)label_image.at<float>(y,x) != 1) {
				continue;
			}

			cv::Rect rect;
			cv::floodFill(label_image, cv::Point(x,y), cv::Scalar(label_count), &rect, cv::Scalar(0), cv::Scalar(0), 4);

			std::vector <cv::Point2i> blob;

			for(int i=rect.y; i < (rect.y+rect.height); i++) {
				for(int j=rect.x; j < (rect.x+rect.width); j++) {
					if((int)label_image.at<float>(i,j) != label_count) {
						continue;
					}

					blob.push_back(cv::Point2i(j,i));
				}
			}

			blobs.push_back(blob);

			label_count++;
		}
	}
}
