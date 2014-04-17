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

	float r=0.1,g=0.1,b=0.1;
	for(float i=2.0;i<6.0;i++){
		float offsetx=i+time*i*10.0;
		
		float amt=1.0-pow(abs(abs(pos.y-1.0)*amp*sin(iter*2.0*PI*pow(pos.y,3.0)+offsetx)+offsety-pos.x),0.09);
		g+=amt*abs(sin(time*0.1+abs(pos.x-0.1)*1.0));
		b+=amt*abs(sin(time*0.1+4.0+abs(pos.x-0.5)*3.0));
	}
	
	gl_FragColor = vec4( vec3( r, g, b), 1.0 );

}

