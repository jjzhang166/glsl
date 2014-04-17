#ifdef GL_ES
precision mediump float;
#endif

uniform float time;
uniform vec2 mouse;
uniform vec2 resolution;

bool inCircle(vec2 pos, vec2 circlePos, float radius)
{
	vec2 diff = circlePos - pos;
	
	return diff.x * diff.x + diff.y * diff.y < radius * radius;
}

bool sameSide(vec2 p1, vec2 p2, vec2 a, vec2 b)
{
	vec3 cp1 = cross(vec3(b - a, 0.0), vec3(p1 - a, 0.0));
	vec3 cp2 = cross(vec3(b - a, 0.0), vec3(p2 - a, 0.0));
	
	return dot(cp1, cp2) >= 0.0;
}

bool inTriangle(vec2 p, vec2 a, vec2 b, vec2 c)
{
	return sameSide(p, a, b, c) && sameSide(p, b, a, c) && sameSide(p, c, a, b);
}

bool inRectangle(vec2 p, vec2 a, vec2 b, vec2 c, vec2 d)
{
	return inTriangle(p, a, b, c) || inTriangle(p, a, c, d);
}

void main( void )
{
	vec2 mid = resolution / 2.0;
	if(inRectangle(gl_FragCoord.xy, mid + vec2(110.0, 140.0), mid + vec2(130.0, 120.0), mid + vec2(50.0, 40.0), mid + vec2(30.0, 60.0))) gl_FragColor = vec4(0.7, 0.2, 0.1, 1.0) * vec4(sin(time) + 0.1, cos(time) + 0.1 , tan(time)+ 0.1 , 1.0);
	else if(inRectangle(gl_FragCoord.xy, mid + vec2(30.0, 120.0), mid + vec2(50.0, 140.0), mid + vec2(130.0, 60.0), mid + vec2(110.0, 40.0))) gl_FragColor = vec4(0.7, 0.2, 0.1, 1.0) * vec4(sin(time) + 0.25, cos(time) + 0.2 , tan(time)+ 0.2 , 1.0);
	else if(inRectangle(gl_FragCoord.xy, mid + vec2(-110.0, 140.0), mid + vec2(-130.0, 120.0), mid + vec2(-50.0, 40.0), mid + vec2(-30.0, 60.0))) gl_FragColor = vec4(0.7, 0.2, 0.1, 1.0) * vec4(sin(time) + sin(time)+ 0.3, cos(time) + sin(time)+ 0.3 , tan(time)+ 0.3 , 1.0);
	else if(inRectangle(gl_FragCoord.xy, mid + vec2(-30.0, 120.0), mid + vec2(-50.0, 140.0), mid + vec2(-130.0, 60.0), mid + vec2(-110.0, 40.0))) gl_FragColor = vec4(0.7, 0.2, 0.1, 1.0) * vec4(sin(time) + sin(time), cos(time) + sin(time) , tan(time)+ sin(time) , 1.0);
	else if(inCircle(gl_FragCoord.xy, mid, 220.0) && gl_FragCoord.y < mid.y - 140.0) gl_FragColor = vec4(0.7, 0.2, 0.1, 1.0) * vec4(sin(time) + sin(time), cos(time) + sin(time) , tan(time)+ sin(time) , 1.0);
	else if(inCircle(gl_FragCoord.xy, mid - vec2(108.0, 160.0), 64.0) && gl_FragCoord.y >= mid.y - 140.0) gl_FragColor = vec4(0.7, 0.2, 0.1, 1.0) * vec4(sin(time) + 0.5, cos(time) + 0.5 , tan(time)+ 0.5 , 1.0);
	else if(inCircle(gl_FragCoord.xy, mid - vec2(-40.0, 160.0), 130.0) && gl_FragCoord.y >= mid.y - 140.0) gl_FragColor = vec4(0.7, 0.2, 0.1, 1.0) * vec4(sin(time) + 0.5, cos(time) + 0.5 , tan(time)+ 0.5 , 1.0);
	else if(inCircle(gl_FragCoord.xy, mid, 220.0) && gl_FragCoord.y < mid.y) gl_FragColor = vec4(0.9, 0.6, 0.4, 1.0) * vec4(sin(time) + 0.5, cos(time) + 0.5 , tan(time)+ 0.5 , 1.0);
	else if(inCircle(gl_FragCoord.xy, mid, 220.0)) gl_FragColor = vec4(0.9, 0.6, 0.4, 1.0) * vec4(sin(time) + 0.5, cos(time) + 0.5 , tan(time)+ 0.5 , 1.0);
	else if(inCircle(gl_FragCoord.xy, mid, 256.0)) gl_FragColor = vec4(0.87, 0.57, 0.37, 1.0) / vec4(sin(time) + 0.5, cos(time) + 0.5 , tan(time)+ 0.5 , 1.0);
	else gl_FragColor = vec4(1.0, 1.0, 1.0, 1.0);
}