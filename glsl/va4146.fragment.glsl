//MG
#ifdef GL_ES
precision mediump float;
#endif

uniform float time;
uniform vec2 mouse;
uniform vec2 resolution;

void main( void ) {
	vec2 pos = gl_FragCoord.xy;
	vec4 color;
	float dist=sqrt((pos.x-resolution.x/4.0)*(pos.x-resolution.x/4.0)+(pos.y-resolution.y/2.0)*(pos.y-resolution.y/2.0));
	
	pos.x=pos.x+time*20.0;
	pos.y=pos.y+time*20.0;
	
	if (dist<resolution.y*30.0/100.0) {
		pos.x+=resolution.x/8.0;
		pos.y+=resolution.y/8.0;
		color.r=mod(pos.x+pos.y,256.0)/256.0;
		color.g=mod(pos.x*2.0+pos.y,256.0)/256.0;
		color.b=mod(pos.x+pos.y*2.0,256.0)/256.0;
		gl_FragColor = color;
	}
	else {
		color.r=mod(pos.x+pos.y,256.0)/256.0;
		color.g=mod(pos.x*2.0+pos.y,256.0)/256.0;
		color.b=mod(pos.x+pos.y*2.0,256.0)/256.0;
		gl_FragColor = color;
	}
}