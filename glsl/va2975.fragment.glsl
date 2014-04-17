// @rotwang: @mod+ HSV colored double checker

#ifdef GL_ES
precision mediump float;
#endif


uniform float time;
uniform vec2 mouse;
uniform vec2 resolution;

vec3 hsv2rgb(float h,float s,float v) {
	return mix(vec3(1.),clamp((abs(fract(h+vec3(3.,2.,1.)/3.)*6.-3.)-1.),0.,1.),s)*v;
}


void main( void ) {

	float aspect = resolution.x / resolution.y;
	vec2 p = ( gl_FragCoord.xy / resolution.xy ); 

	float hue1 = 0.0;
	
	vec2 t1 = p*4.0;
	t1.x *= aspect;
	if( mod(t1.x, 2.0) > 1. == mod(t1.y, 2.0) > 1. )
		hue1 = p.x*4.0; 
	else 
		hue1 = 1.0-p.x;
	
	float hue2 = 0.0;
	vec2 t2 = p*8.0;
	t2.x *= aspect;
	if( mod(t2.x, 2.0) > 1. == mod(t2.y, 2.0) > 1. )
		hue2 = 1.0-p.x; 
	else 
		hue2 = p.x*4.0;
	
	
	
	float hue = mix( hue1, hue2, 0.5);
	float sat = 0.4;
	float lum = 0.8;
	vec3 hsv = hsv2rgb( hue, sat,lum); 
	
	gl_FragColor = vec4( hsv, 1.0 );

}