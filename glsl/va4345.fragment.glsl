//MrOMGWTF
//I have no idea what is it
//Looks cool tho

precision highp float;

uniform float time;
uniform vec2 mouse;
uniform sampler2D bb;
uniform vec2 resolution;
float motionblur_size = 2.0;

vec3 thing(vec2 uv, vec2 pos, vec3 color, float rad)
{
	return color * (1.0 / distance(uv, pos) * rad);	
}

void main( void ) {

   	vec2 p=(gl_FragCoord.xy/resolution.x)*2.0-vec2(1.0,resolution.y/resolution.x);
	p=p*4.0;
	vec3 color = vec3(0.0);
	color += thing(p, vec2(0.0), vec3(1.0, 1.0, 0.6), 0.05);
	color += thing(p, vec2(sin(time * 2.0), cos(time * 2.0)) * 0.25, vec3(0.5, 0.5, 1.0), 0.01);
	color += thing(p, vec2(-sin(time * 2.0), -cos(time * 1.0)) * 0.25, vec3(0.5, 0.5, 1.0), 0.01);

	color += thing(p, vec2(sin(time * 1.0 + 0.25), cos(time * 1.0 + 0.25)) * 0.5, vec3(0.5, 0.5, 1.0), 0.01);
	color += thing(p, vec2(sin(-time * 1.0 + 0.5), cos(time * 1.0+ 0.5)) * 0.3, vec3(0.5, 0.5, 1.0), 0.01);
	color += thing(p, vec2(sin(time * 1.0 + 0.75), cos(-time * 1.0+ 0.75)) * 0.6, vec3(0.5, 0.5, 1.0), 0.01);
	color += thing(p, vec2(sin(time * 1.0 + 1.0), cos(time * 1.0+ 1.0)) * 0.8, vec3(0.5, 0.5, 1.0), 0.01);
	
	color += thing(p, vec2(sin(time * 1.0 + 0.25), cos(time * 1.0 + 0.25)) * 1.5, vec3(1.0, 0.5, 0.5), 0.02);
	color += thing(p, vec2(sin(-time * 1.0 + 0.5), cos(-time * 1.0+ 0.5)) * 1.3, vec3(1.0, 0.5, 0.5), 0.02);
	color += thing(p, vec2(sin(time * 1.0 + 0.75), cos(-time * 1.0+ 0.75)) * 1.6, vec3(1.0, 0.5, 0.5), 0.02);
	color += thing(p, vec2(sin(time * 1.0 + 1.0), cos(time * 1.0+ 1.0)) * 1.8, vec3(1.0, 0.5, 0.5), 0.02);
	
	
	vec2 uv = gl_FragCoord.xy/resolution;
	color += texture2D(bb, vec2(uv.x, uv.y)).xyz * motionblur_size;
	color /= motionblur_size + 1.0;
	gl_FragColor = vec4( color, 1.0 );

}