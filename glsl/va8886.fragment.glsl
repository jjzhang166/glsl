#ifdef GL_ES
precision mediump float;
#endif

uniform float time;
uniform vec2 mouse;
uniform vec2 resolution;

 const highp vec2 center = vec2(0.5, 0.5);
 const highp float radius = 0.5;
 const highp float gradRadius = 0.55;
 const highp float innerRadius = 0.495;
 const highp float gradFalloff = 0.2;

void main(void)
{
	vec2 uv = gl_FragCoord.xy / resolution.xy;
	
	highp float distanceFromCenter = distance(center, uv);
    lowp float outerCircle = step(distanceFromCenter, radius);
	lowp float innerCircle = step(distanceFromCenter, innerRadius);
	lowp float gradCircle = smoothstep(distanceFromCenter, distanceFromCenter + gradFalloff, gradRadius);
	
	lowp vec4 innerColor = vec4(1.0) * outerCircle - vec4(1.0) * gradCircle;
	lowp vec4 edgeColor = vec4(1.0) * outerCircle - vec4(1.0) * innerCircle;
    gl_FragColor =  edgeColor * edgeColor.a + innerColor * (1.0 - edgeColor.a); 
	
}