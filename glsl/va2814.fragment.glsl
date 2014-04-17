#version 110
//Global variables

//uniform qualified variables are changed at most once per primitive
uniform float CoolestTemp;
uniform float TempRange;
uniform mat4 MVPMatrix;

//in qualified variables are typically changed per vertex
in vec4 mcVertex;
in float VertexTemp;

//out qualified variables communicate from the vertex shader to the fragment shader
out float Temperature;

void main()
{
	//compute a temperature to be interpolated per fragment
	//in the range [0.0, 1.0]
	Temperature = (VertexTemp - CoolestTemp) / TempRange;
	gl_Position = MVPMatrix * mcVertex;
}