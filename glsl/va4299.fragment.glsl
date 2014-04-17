#ifdef GL_ES
precision mediump float;
#endif

uniform float time;
uniform vec2 mouse;
uniform vec2 resolution;
uniform sampler2D buff;

#define PI 3.14159


//hsv bad motion blur thing

//stole this from one of the many shaders that use it (who originally made it so I can give credit)
vec3 hsv2rgb(float h,float s,float v) {
	return mix(vec3(1.),clamp((abs(fract(h+vec3(3.,2.,1.)/3.)*6.-3.)-1.),0.,1.),s)*v;
}

void main( void ) {
	vec4 col;
	vec2 pos = ( gl_FragCoord.xy / resolution.xy );
	
	
	float speed=2.*PI;
	//vec2 tpos=vec2(cos(time*speed),sin(time*speed))*0.25+vec2(0.5);
	vec2 tpos=mouse;
	
	float m=1./pow(distance(tpos,pos),2.)*0.0005;
	col=vec4(hsv2rgb(mod(time*0.25,1.),1.,1.),1.)*m;
		
	col+=texture2D(buff,pos);
	gl_FragColor = col/1.05;

}