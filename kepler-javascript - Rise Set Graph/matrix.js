function MatrixMul(a,b){
	//Only works for 3x3 times 1x3
	var x=a[0][0]*b.x+a[1][0]*b.y+a[2][0]*b.z;
	var y=a[0][1]*b.x+a[1][1]*b.y+a[2][1]*b.z;
	var z=a[0][2]*b.x+a[1][2]*b.y+a[2][2]*b.z;

	b.x=x;
	b.y=y;
	b.z=z;
}

function GetXRotationMatrix(rad){
	var matrix=new Array();
	matrix[0]=new Array();
	matrix[1]=new Array();
	matrix[2]=new Array();

	matrix[0][0]=1;
	matrix[0][1]=0;
	matrix[0][2]=0;
	matrix[1][0]=0;
	matrix[1][1]=Math.cos(rad);
	matrix[1][2]=Math.sin(rad);
	matrix[2][0]=0;
	matrix[2][1]=-Math.sin(rad);
	matrix[2][2]=Math.cos(rad);

	return matrix;
}

function GetYRotationMatrix(rad){
	var matrix=new Array();
	matrix[0]=new Array();
	matrix[1]=new Array();
	matrix[2]=new Array();

	matrix[0][0]=Math.cos(rad);
	matrix[0][1]=0;
	matrix[0][2]=-Math.sin(rad);
	matrix[1][0]=0;
	matrix[1][1]=1;
	matrix[1][2]=0;
	matrix[2][0]=Math.sin(rad);
	matrix[2][1]=0;
	matrix[2][2]=Math.cos(rad);

}

function GetZRotationMatrix(rad){
	var matrix=new Array();
	matrix[0]=new Array();
	matrix[1]=new Array();
	matrix[2]=new Array();

	matrix[0][0]=Math.cos(rad);
	matrix[0][1]=Math.sin(rad);
	matrix[0][2]=0;
	matrix[1][0]=-Math.sin(rad);
	matrix[1][1]=Math.cos(rad);
	matrix[1][2]=0;
	matrix[2][0]=0;
	matrix[2][1]=0;
	matrix[2][2]=1;

}
