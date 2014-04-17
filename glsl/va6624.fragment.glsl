#ifdef GL_ES
precision mediump float;
#endif

uniform float time;
uniform vec2 mouse;
uniform vec2 resolution;

//http://www.easyrgb.com/index.php?X=MATH
vec3 xyz2rgb(vec3 col)
{
	float var_X = col.x / 100.0;       //X from 0 to  95.047      (Observer = 2°, Illuminant = D65)
	float var_Y = col.y / 100.0;       //Y from 0 to 100.000
	float var_Z = col.z / 100.0;       //Z from 0 to 108.883
		
	float var_R = var_X *  3.2406 + var_Y * -1.5372 + var_Z * -0.4986;
	float var_G = var_X * -0.9689 + var_Y *  1.8758 + var_Z *  0.0415;
	float var_B = var_X *  0.0557 + var_Y * -0.2040 + var_Z *  1.0570;
		
	if ( var_R > 0.0031308 ) 
	{
		var_R = 1.055 * pow( var_R , ( 1.0 / 2.4 ) ) - 0.055;
	}		
	else
	{
		var_R = 12.92 * var_R;
	}
	if ( var_G > 0.0031308 )
	{
		var_G = 1.055 * pow( var_G , ( 1.0 / 2.4 ) ) - 0.055;
	}
	else 
	{
		var_G = 12.92 * var_G;
	}
	if ( var_B > 0.0031308 )
	{
		var_B = 1.055 * pow( var_B , ( 1.0 / 2.4 ) ) - 0.055;
	}
	else 
	{
		var_B = 12.92 * var_B;
	}

	//R = var_R * 255
	//G = var_G * 255
	//B = var_B * 255
	return vec3(var_R,var_G,var_B);
	
}
vec3 lab2xyz(vec3 col)
{
	float var_Y = ( col.x + 16.0 ) / 116.0;
	float var_X = col.y / 500.0 + var_Y;
	float var_Z = var_Y - col.z / 200.0;
		
	if ( pow(var_Y,3.0) > 0.008856 ) 
	{
		var_Y = pow(var_Y,3.0);
	}
	else
	{
		var_Y = ( var_Y - 16.0 / 116.0 ) / 7.787;
	}
	if ( pow(var_X,3.0) > 0.008856 )
	{
		var_X = pow(var_X,3.0);
	}
	else 
	{
		var_X = ( var_X - 16.0 / 116.0 ) / 7.787;
	}
	if ( pow(var_Z,3.0) > 0.008856 )
	{
		var_Z = pow(var_Z,3.0);
	}
	else  
	{
		var_Z = ( var_Z - 16.0 / 116.0 ) / 7.787;
	}

	//X = ref_X * var_X;     //ref_X =  95.047     Observer= 2°, Illuminant= D65
	//Y = ref_Y * var_Y;     //ref_Y = 100.000
	//Z = ref_Z * var_Z;     //ref_Z = 108.883
	return vec3(95.047* var_X,100.000* var_Y,108.883* var_Z);
}
void main( void ) {

	vec2 p = ( gl_FragCoord.xy / resolution.xy );

	vec3 color = vec3((1.-length(p-0.5))*0.90,p.x,p.y);
	
	color = lab2xyz(((color-vec3(0.5))*2.0)*128.);
	color = xyz2rgb(color);
	

	gl_FragColor = vec4( vec3( color ), 1.0 );

}