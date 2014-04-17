#ifdef GL_ES
precision highp float;
#endif

uniform float time;
uniform vec2 mouse;
uniform vec2 resolution;
#define PI 3.1415926535897932384626433832795
#define amp 0.2
#define iter 5.0
#define offsety 0.5

void main( void ) {


	vec2 pos =  gl_FragCoord.xy/resolution ;

	float r=0.0,g=0.0,b=0.0;
	for(float i=1.0;i<11.0;i++){
		float offsetx=i+time*i*0.5;
		
		float amt=1.0-pow(abs(abs(pos.x-1.0)*amp*sin(iter*2.0*PI*pow(pos.x,3.0)+offsetx)+offsety-pos.y),0.03);
		g+=amt*abs(sin(time*0.1+abs(pos.y-0.5)*3.0));
		//r+=amt*abs(sin(time*0.1+2.0+abs(pos.y-0.5)*3.0));
		b+=amt*abs(sin(time*0.1+4.0+abs(pos.y-0.5)*3.0));
		}
	
	//if(pow(pos.x+pos.y,3.0)>0.5)r=sin(time);
	gl_FragColor = vec4( vec3( r, g, b), 0 );

}

