#ifdef GL_ES
precision mediump float;
#endif

// An attempt to create a generalize the "Game of Life". Not as beautiful as https://www.youtube.com/watch?feature=player_embedded&v=KJe9H6qS82I though...

uniform float time;
uniform vec2 mouse;
uniform vec2 resolution;
uniform sampler2D backbuffer;

const float o0 = 0.09842431980260889;
const float o1 = 0.09572793409714866;
const float o2 = 0.08807395109008559;
const float o3 = 0.07665293733554218;
const float o4 = 0.06310774360199084;
const float o5 = 0.04914836013509991;
const float o6 = 0.03620828376666309;
const float o7 = 0.025233609465739288;
const float o8 = 0.016635020606425854;

const float i0 = 0.09842431980260889;
const float i1 = 0.09572793409714866;
const float i2 = 0.08807395109008559;
const float i3 = 0.07665293733554218;
const float i4 = 0.06310774360199084;
const float i5 = 0.04914836013509991;
const float i6 = 0.03620828376666309;
const float i7 = 0.025233609465739288;
const float i8 = 0.016635020606425854;

vec2 getX(float pos, float scale1, float scale2) {
	return texture2D(backbuffer, (gl_FragCoord.xy+vec2(pos,0.)) / resolution.xy).yy*vec2(scale1,scale2);
}

vec2 getX2(float pos, float scale1, float scale2) {
	return getX(pos,scale1,scale2)+getX(-pos,scale1,scale2);
}

vec2 getY(float pos, float scale1, float scale2) {
	return texture2D(backbuffer, (gl_FragCoord.xy+vec2(0.,pos)) / resolution.xy).zw*vec2(scale1,scale2);
}

vec2 getY2(float pos, float scale1, float scale2) {
	return getY(pos,scale1,scale2)+getY(-pos,scale1,scale2);
}

void main( void ) {
	// r,g: main value
	// b,a: blurred version
	
	vec2 position = ( gl_FragCoord.xy / resolution.xy );
	float dist = length(position-mouse);

	vec2 ba = getX(0.,i0,o0) + getX2(1.,i1,o1) + getX2(2.,i2,o2) + getX2(3.,i3,o3) + getX2(4.,i4,o4) + getX2(5.,i5,o5) + getX2(6.,i6,o6) + getX2(7.,i7,o7) + getX2(8.,i8,o8);
	float time = 10.;
	
	vec2 rg = getY(0.,i0,o0) + getY2(1.,i1,o1) + getY2(2.,i2,o2) + getY2(3.,i3,o3) + getY2(4.,i4,o4) + getY2(5.,i5,o5) + getY2(6.,i6,o6) + getY2(7.,i7,o7) + getY2(8.,i8,o8);
	
	float alive = texture2D(backbuffer, gl_FragCoord.xy / resolution.xy).y;
	float alive2 = (rg.g-rg.r*.33-.15+.0003/dist)*21.;
	float peak = 1.+alive*1.2;
	float alive3 = max(0.,peak-abs(peak-alive2));
	
	


	gl_FragColor = vec4( alive3*10., (dist<.03 ? sin(position.x*position.y*10000.+dot(position+mouse,vec2(2120.14,10637.))) :  alive3 ), ba );

}