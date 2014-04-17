#ifdef GL_ES
precision highp float;
#endif

uniform float time;
uniform vec2 mouse;
uniform vec2 resolution;
float pi=3.14159;
vec2 eyePosition=vec2(0.0,20.0);

bool inCircle(vec2 circleCenter, float radius)
{
	vec2 temp = gl_FragCoord.xy - circleCenter.xy;
	if(temp.x*temp.x+temp.y*temp.y<radius*radius) return true;
	return false;
}

bool inBorder(vec2 circleCenter, float radius,float pixelWidth)
{
	vec2 temp = gl_FragCoord.xy - circleCenter.xy;
	if((temp.x*temp.x+temp.y*temp.y>radius*radius-pixelWidth)&&(temp.x*temp.x+temp.y*temp.y<radius*radius)) return true;
	return false;
}

bool inMouth(vec2 circleCenter, float radius,float maxAngle)
{
	vec2 temp = gl_FragCoord.xy - circleCenter.xy;
	if(((temp.y>temp.x*sin(maxAngle))&&(temp.y<temp.x*sin(-maxAngle)))&&(temp.x*temp.x+temp.y*temp.y<radius*radius)) return true;
	return false;
}

bool inEye(vec2 circleCenter, vec2 eyePos,float eyeRadius)
{
	vec2 temp = gl_FragCoord.xy - circleCenter.xy- eyePos;
	if((temp.x*temp.x+temp.y*temp.y<eyeRadius*eyeRadius)) return true;
	return false;
}

void main( void ) {
	vec2 center = resolution/2.0;
	center.x=mod(time*100.0,resolution.x);
	float radius = 50.0;
	
	if(inCircle(center, radius)&&!inMouth(center, radius,mod(time*4.0,-pi))) 
		gl_FragColor = vec4(1.0,1.0,-0.0,1.0);
	else
		gl_FragColor = vec4(vec3(0.0), 1.0);
	
	if(inEye(center, eyePosition,6.0)||inBorder(center, radius,100.0)&&!inMouth(center, radius,mod(time*4.0,-pi))) 
		gl_FragColor = vec4(0.0,0.0,0.0,1.0);

}