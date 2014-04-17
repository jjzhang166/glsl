#ifdef GL_ES
precision mediump float;
#endif
//sexy motion blur :DD
//by MrOMGWTF
uniform float time;
uniform vec2 mouse;
uniform vec2 resolution;
uniform sampler2D bbuff;

float makePoint(vec2 uv, vec2 pos, float rad)
{
	return 1.0 / distance(uv, pos) * rad;	
}

void main( void ) {

	vec2 p=(gl_FragCoord.xy/resolution.x)*2.0-vec2(1.0,resolution.y/resolution.x);
	vec2 uv = ( gl_FragCoord.xy / resolution.xy );
	vec2 pointPos = vec2(sin(time * 0.5), cos(time * 2.0) * 0.3);
	vec3 color;
	color += makePoint(p, pointPos, 0.002);
	
	color = pow(color, vec3(1.9, 1.1, 0.9));
	color += texture2D(bbuff, vec2(uv) + vec2(0.001, 0.005)).xyz * 0.495;
	color += texture2D(bbuff, vec2(uv) - vec2(0.001, 0.005)).xyz * 0.495;
	gl_FragColor = vec4( color, 1.0 );

}