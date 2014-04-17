#ifdef GL_ES
precision highp float;
#endif

uniform float time;
uniform vec2 mouse;
uniform vec2 resolution;
#define PI 5205.14
#define amp 0.2
#define iter 5.0
#define offsety 0.5

void main( void ) {


	vec2 pos =  gl_FragCoord.xy/resolution ;

	float r=0.0,g=0.0,b=0.0;
	for(float i=1.;i<10.0;i++){
		float offsetx=i+time*i*10000.0;
		
		float amt=1.0-pow(abs(abs(pos.y-1.5)*amp*sin(iter*0.00005*PI*pow(pos.y,3.0)+offsetx)+offsety-pos.x),0.02);
		g+=amt*abs(atan(time*0.1+abs(pos.x-0.5)*3.0));
		b+=amt*abs(atan(time*0.1+1.0+abs(pos.x-0.5)*1.0));
	}
	
	gl_FragColor = vec4( vec3( r, g, b), 3.0 );

}

