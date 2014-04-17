#ifdef GL_ES
precision mediump float;
#endif
uniform float time;
uniform vec2 mouse;
uniform vec2 resolution;
uniform sampler2D backbuffer;

float y(vec2 vec){
	float x= vec.x;
	float z= vec.y;//swizzle for readability
	if(x<0.0) x=-x;
	if(z<0.0) z=-z;
	float t= mod(time,2.0)+1.;
	
	return (
		sin(x*z +(time)*2.0) 
		)/2.0+0.5;
	//return sqrt(x*x+z*z+t*t);
}

//return normals and y pos
vec4 f(vec2 vec){
	float scale=mouse.y*100.0;
	
	vec/=scale;
	
	float yres= y(vec);
		
	//approximate differentials with tangents
	//is less writing, but is more than 2x slower
	const float d=0.25;
	vec4 res=  vec4(
			( y(vec+vec2(d,0))-yres )/d,//dy/dx
			1,
		    	( y(vec+vec2(0,d))-yres )/d,//dy/dz
		   	 yres
		);
	
	//1 is normalized to either but not both differentials
	//so they need normalized with respect to eachother
	res.xyz= normalize(res.xyz);
	return res;
}

float check(vec2 pos){
	float res= f(pos).w;
	bool inRange= (pos.y>=res-0.5) && (pos.y<=res+0.5);
	return inRange ? 1.0 : 0.0;
}


void main( void ) {
	vec2 pos = ( gl_FragCoord.xy ); //* mouse / 4.0;
	pos.y-= resolution.y/2.0;
	pos.x-= resolution.x/2.0;

	//5X averaged antialiasing
	vec4 res0= f(pos);//middle
	vec4 res1= f(pos+vec2(-0.25, -0.25));//bot right
	vec4 res2= f(pos+vec2(-0.25,  0.25));//top right
	vec4 res3= f(pos+vec2( 0.25, -0.25));//bot left
	vec4 res4= f(pos+vec2( 0.25,  0.25));//top left
	
	
	vec4 res= (res0+res1+res2+res3+res4)/5.0;

	//do lighting using the normal plane's slope
	float col= abs(cross(vec3(1.0,1.0,1.0),res.xyz).y)*.45+0.3;
	
	gl_FragColor = vec4(col,col,col,1);
	//gl_FragColor = vec4(res.x,res.y,res.z,1);
	//gl_FragColor = vec4(res.w,res.w,res.w,1);
}