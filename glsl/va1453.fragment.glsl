/**

###Anaglyph 3d tunnel###
by Ralph Hauwert / @UnitZeroOne / UnitZeroOne.com
Put on your red / magenta anaglyph glasses and enjoy the trip.
**/

#ifdef GL_ES
precision mediump float;
#endif

uniform float time;
uniform vec2 mouse;
uniform vec2 resolution;

//There is a nasty bug on chrome (at leat mine), that breaks on any usage of cos, workaround with the mycos define below.
#define mycos(x) sin(1.57079633-x) 

vec3 roy(vec3 v, float x)
{
    return vec3(mycos(x)*v.x - sin(x)*v.z,v.y,sin(x)*v.x + mycos(x)*v.z);
}

vec3 rox(vec3 v, float x)
{
    return vec3(v.x,v.y*mycos(x) - v.z*sin(x),v.y*sin(x) + v.z*mycos(x));
}

float fdtun(vec3 rd, vec3 ro, float r)
{
	float a = dot(rd.xy,rd.xy);
  	float b = dot(ro.xy,rd.xy);
	float d = (b*b)-(.1*b*(dot(ro.xy,ro.xy)+(r*r)));
  	return (-b+sqrt(abs(d)))/(2.0*d*b);
}

vec2 tunuv(vec3 pos){
	return vec2(pos.z,(atan(pos.y, pos.x))/0.18379);
}

vec3 checkerCol(vec2 loc, vec3 col)
{
	return mix(col, vec3(0.0), mod(step(fract(loc.x), 0.9) + step(fract(loc.y), 0.5), 2.0));
}

vec3 lcheckcol(vec2 loc, vec3 col)
{
	return checkerCol(loc*1.10,col)*checkerCol(loc*5.8,col);	
}

void main( void ) {
	vec3 dif = vec3(1.20,0.0,0.0);
	vec3 scoll = vec3(0.1,1.0,1.0);
	vec3 scolr = vec3(1.0,0.0,0.0);
	vec2 uv = (gl_FragCoord.xy/resolution.xy);
	vec3 ro = vec3(0.0,0.0,time*9.0);
	vec3 dir = normalize( vec3( -0.0 + 3.0*vec2(uv.x - .1, uv.y)* vec2(resolution.x/resolution.y, 1.0), -1.33 ) );

	float ry = time*0.1;
	
	dir = roy(rox(dir,time*0.1),time*0.3);
	vec3 lro = ro-dif;
	vec3 rro = ro+dif;

	const float r = 0.1;
	float ld = fdtun(dir,lro,r);
	float rd = fdtun(dir,rro,r);
	vec2 luv = tunuv(ro + ld*dir);
	vec2 ruv = tunuv(ro + rd*dir);
	vec3 coll = lcheckcol(luv*.6,scoll)*(5.0/exp(sqrt(ld)));
	vec3 colr = lcheckcol(ruv*.1,scolr)*(10.0/exp(sqrt(rd)));
	gl_FragColor = vec4(sqrt(coll+colr),1.0);
}