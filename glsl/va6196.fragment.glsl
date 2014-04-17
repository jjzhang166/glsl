#ifdef GL_ES
precision mediump float;
#endif
//sexy motion blur :DD
//by MrOMGWTF
//sexiness improved
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
	vec2 pointPos;
	pointPos = mouse;
	pointPos.x *= 2.;
	pointPos.x -= 1.;
	pointPos.y -= .5;
	vec2 vary = vec2(sin(time * 3.0), cos(time * 3.0));
	vary *= .25;
	pointPos += vary;
	vec3 color;
	float size = .0025 + .0025 * abs(sin(time * .5));
	color += makePoint(p, pointPos, size);
	color += makePoint(p, -pointPos, size);
	
	float red = mouse.x + .75;
	float green = mouse.y + .75;
	float blue = abs(sin(time*.35)) + 1.25;
	
	//color = pow(color, vec3(1.9, 1.1, 0.9));
	color = pow(color, vec3(red, green, blue));
	color += texture2D(bbuff, vec2(uv) + vec2(-0.005, 0.005)).xyz * .15;
	color += texture2D(bbuff, vec2(uv) + vec2(-0.005, -0.005)).xyz * .15;
	color += texture2D(bbuff, vec2(uv) + vec2(0.005, -0.005)).xyz * .15;
	color += texture2D(bbuff, vec2(uv) + vec2(0.005, 0.005)).xyz * .15;
	color += texture2D(bbuff, vec2(uv)).xyz * .35;
	
	
	
	gl_FragColor = vec4( color, 1.0 );

}