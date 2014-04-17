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

	float r=0.60,g=0.0,b=0.0;
	for(float i=1.0;i<5.0;i++){
		float offsetx=i+time*i*0.5;
		
		float amt=1.0-pow(abs(amp*cos(iter*-2.0*PI*pow(pos.x,0.9)+offsetx)+offsety-pos.y),0.03);
		g+=amt*abs(sin(time*0.1+abs(pos.y-0.5)*3.0));
		b+=amt*abs(sin(time*0.1+4.0+abs(pos.y-0.5)*3.0));
	}
	
	gl_FragColor = vec4( vec3( r, g, b), 1.0 );

}

