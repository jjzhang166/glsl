#ifdef GL_ES
precision mediump float;
#endif

uniform float time;
uniform vec2 mouse;
uniform vec2 resolution;
uniform sampler2D buff;

#define PI 3.14159


//I can make glowing sines too
//set to 1 for best results

vec3 hsv2rgb(float h,float s,float v) {
	return mix(vec3(1.),clamp((abs(fract(h+vec3(3.,2.,1.)/3.)*6.-3.)-1.),0.,1.),s)*v;
}


void main( void ) {

	vec2 pos = ( gl_FragCoord.xy / resolution.xy );
	
	vec2 m=mouse-vec2(0.5,0.5);
	
	float s=0.002/abs(-0.5+pos.y-0.25*sin(-4.*PI*time)*sin(-4.*PI*time+4.*PI*pos.x));
	vec3 col=hsv2rgb(mod(0.125*time,1.),1.,1.)*s;
	col+=texture2D(buff,pos+vec2(0.,0.002)).rgb*0.96;
	gl_FragColor = vec4(col,1.);

}