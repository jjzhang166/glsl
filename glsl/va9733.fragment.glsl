#ifdef GL_ES
precision mediump float;
#endif

uniform float time;
uniform vec2 mouse;
uniform vec2 resolution;

void main( void ) {

	vec2 p = ( time*0.0001+gl_FragCoord.xy / resolution.xy );

	float color = cos(time*0.2+p.x)-cos(p.x*p.y/cos(time*0.3+p.x))+p.y-abs((p.x*(p.x+cos(p.y+time*0.35)) * sin(p.y/tan(p.x+time*0.34)))*0.45);
	float color2 = sin(time*0.3+p.y*0.001)/sin(p.x/p.y-sin(time*0.2+p.x))/p.x+abs((p.y*(p.x+sin(p.x+time*0.45)) * cos(p.y/atan(p.x+time*0.5)))*0.5);
	float color3 = cos(time*0.5+p.y*0.5)*tan(p.x-p.y/tan(time*0.5+p.x))*p.y-abs((p.x*(p.y+atan(p.y+time*0.5)) * tan(p.y/cos(p.x+time*0.555)))*0.55);

		float xx = cos(time*0.5+p.x*1.0+color3)*p.y*0.5*color;
	float kk = abs(cos(time*100.0+xx)*0.5);
	gl_FragColor = vec4( vec3( fract(xx-color-color2)*(1.0+kk), fract(xx-color-color2)*(1.0+kk), fract(xx-color-color2)*(1.0+kk)), 1.0 );

}