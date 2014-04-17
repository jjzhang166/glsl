// rotwang mod* much

#ifdef GL_ES
precision mediump float;
#endif

uniform float time;
uniform vec2 mouse;
uniform vec2 resolution;


vec3 hsv2rgb(float h,float s,float v) {
	return mix(vec3(1.),clamp((abs(fract(h+vec3(3.,2.,1.)/3.)*6.-3.)-1.),0.,1.),s)*v;
}

void main( void ) 
{
	float speed = time*0.5;
	float aspect = resolution.x /resolution.y;
	vec2 unipos = ( gl_FragCoord.xy / resolution );
	vec2 pos = unipos*2.0-1.0;
	pos.x *=aspect;
	
	vec2 position = (gl_FragCoord.xy - resolution * 0.7) / resolution.yy;
	
	float longest = sqrt(float(resolution.x*resolution.x) + float(resolution.y*resolution.y))*0.5;
	float dx = gl_FragCoord.x-resolution.x/2.0;
	float dy = 1.01	+gl_FragCoord.y-resolution.y/2.0;
	float len = sqrt(dx*dx+dy*dy);
	float ds = len/longest;
	float md = time*0.5;
	
	float ang =  abs(atan(dy,(ds*dx)))/ds;

	
	float hue = 0.5 +  sin(ang )*0.5+0.5;
	hue /= 8.0;
	float sat =  cos(ang + md*2.0);
	float lum =  sin(ang  + md*2.0) * length(pos);

	vec3 clr = hsv2rgb(hue,sat,lum);
		
	gl_FragColor = vec4( clr, 1.0 );

}