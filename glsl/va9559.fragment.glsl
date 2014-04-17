// Based on....
// Cellular Colorspiller Fun
// http://twitter.com/rianflo
// 
// Can someone fix the gap on the left hand side that doesn't expand properly??

#ifdef GL_ES
precision mediump float;
#endif

uniform float time;
uniform vec2 mouse;
uniform vec2 resolution;
uniform sampler2D backbuffer;


vec3 nrand3( vec2 co )
{
	vec3 a = fract( cos( co.x*8.3e-3 + co.y )*vec3(1.3e5, 4.7e5, 2.9e5) );
	vec3 b = fract( sin( co.x*0.3e-3 + co.y )*vec3(8.1e5, 1.0e5, 0.1e5) );
	vec3 c = mix(a, b, 0.5);
	return c;
}

float randb(vec2 co){
    return (fract(sin(dot(co.xy ,vec2(12.9898,78.233))) * 43758.5453) > 0.75) ? 1.0 : 0.0;
}

void main( void ) 
{
	vec2 D = vec2(1.0)/resolution;
	vec2 m  = mouse*resolution;
	vec2 uv = gl_FragCoord.xy / resolution;
	
	//move uv towards center so it causes a zoom in effect
	//gl_fragcoord goes from 0,0 lower left to imagesizewidth,imagesizeheight at upper right
	float deltax = gl_FragCoord.x-resolution.x/2.0;
	float deltay = gl_FragCoord.y-resolution.y/2.0;
	float angleradians = atan(deltay,deltax) * 90.;
	//now walk the vector/angle between current pixel and center of screen to get pixel to average around
	float zoomrate=3.0;
    float newx = gl_FragCoord.x + cos(angleradians)*zoomrate;
    float newy = gl_FragCoord.y + sin(angleradians)*zoomrate;
	uv = vec2(newx,newy)/resolution;
	
	// sample 8-neighborhood
	vec4 dL = texture2D(backbuffer, uv+vec2(-D.x, 0.0));
	vec4 dR = texture2D(backbuffer, uv+vec2(D.x, 0.0));
	vec4 dU = texture2D(backbuffer, uv+vec2(0.0, D.y));
	vec4 dD = texture2D(backbuffer, uv+vec2(0.0, -D.y));
	vec4 dUL = texture2D(backbuffer, uv+vec2(-D.x, D.y));
	vec4 dUR = texture2D(backbuffer, uv+vec2(D.x, D.y));
	vec4 dLL = texture2D(backbuffer, uv+vec2(-D.x, -D.y));
	vec4 dLR = texture2D(backbuffer, uv+vec2(D.x, -D.y));
	
	// PLAY WITH ME:
	// ====================================
	// vec4 s = (dL*dR+dU+dD+dUL+dUR+dLL*dLR);
	   vec4 s = (dL*dR+dU*dD+dUL+dUR+dLL+dLR);
	//   vec4 s = (dL+dR+dU+dD+dUL+dUR+dLL+dLR);
	// ====================================
	vec4 val = vec4(normalize(s.xyz), s.w / 8.0);
	
	//val = (length(gl_FragCoord.xy - m.xy) <= 20.0) ? vec4(nrand3(mouse.xy), 1.0) : val;
	
	if(length(m-gl_FragCoord.xy) < 65. )
	{
		val = vec4(nrand3(vec2(time)), 1.0);
	}
	
	
	val /= val.w;
	gl_FragColor = vec4(val);

}