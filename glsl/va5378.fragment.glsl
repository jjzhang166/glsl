#ifdef GL_ES
precision mediump float;
#endif

//just practicing fills, rotation and reflection matrices

uniform float time;
uniform vec2 mouse;
uniform vec2 resolution;
float PI = 3.14159265;

float getAngleFromMouse(vec2 pos)
{
	pos.x = abs(pos.x)/resolution.x;
	pos.y = abs(pos.y)/resolution.y;
	
	float t = 0.0;
	
	if(mouse.x >= pos.x && mouse.y >= pos.y)
	{
		t = -atan((mouse.x-pos.x)/(mouse.y-pos.y));
	}
	else if(mouse.x >= pos.x && mouse.y < pos.y)
	{
		t = -acos((mouse.x-pos.x)/distance(mouse, pos)) - PI*0.5;
	}
	else if(mouse.x < pos.x && mouse.y >= pos.y)
	{
		t = -asin((mouse.x-pos.x)/distance(mouse, pos));
	}
	else
	{
		t = atan((mouse.y-pos.y)/(mouse.x-pos.x)) + PI*0.5;
	}
	
	if(t < 0.0) t += 2.0*PI;
	
	return t;
}

void main( void ) {
	vec2 fragCoord = gl_FragCoord.xy;
	vec2 center = vec2(-resolution.x/2.0, -resolution.y/2.0);
	
	float t = getAngleFromMouse(center);

	mat2 rot = mat2(cos(t), -sin(t), sin(t), cos(t));
	mat2 ref = mat2(1.0, 0.0, 0.0, -1.0);
	float softness = 50.0;
	
	//offset
	vec2 offset = center;
	fragCoord = fragCoord + offset;
	
	//rotation
	fragCoord = rot*fragCoord;		
	float rotColor = abs(pow(fragCoord.x,2.0) - fragCoord.y);
	rotColor /= softness;
	if(rotColor >= 0.7) rotColor = 0.7;
	
	//do reflection
	fragCoord = ref*fragCoord;
	float refColor = abs(pow(fragCoord.x,2.0) - fragCoord.y);
	refColor /= softness;
	refColor *= distance(fragCoord.xy, center)*0.006;
	if(refColor >= 0.7) refColor = 0.7;
	
	//check fill
	float fill = sqrt(fragCoord.y) > abs(fragCoord.x) ? 1.0 : 0.0;
	fill *= 1.0-(fragCoord.y - center.y)/resolution.y;
	
	float r = (rotColor + refColor*0.3 + fill)/3.0;
	float g = (rotColor + refColor*0.3 + fill)/3.0;
	float b = (rotColor + refColor*0.3 + fill)/3.0;
	
	gl_FragColor = vec4(r, g, b, 1.0);
}