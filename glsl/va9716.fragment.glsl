#ifdef GL_ES
precision mediump float;
#endif
// mods by dist

uniform float time;
uniform vec2 mouse;
uniform vec2 resolution;
uniform sampler2D tex;

void main( void )
{
	vec2 p = gl_FragCoord.xy / resolution.xy * 2.0 - 0.5;
	
	vec2 uPos = ( gl_FragCoord.xy / resolution.xy );//normalize wrt y axis
	uPos *= 5.0;
	uPos = abs(uPos);
	uPos -= vec2((resolution.x/resolution.y)/1.05, 0.0);//shift origin to center
	//uPos.x -= 1.5;
	uPos.y -= 2.0;
	
	vec3 color = vec3(0.0);
	float vertColor = 0.0;
	for( float i = 0.0; i < 5.0; ++i )
	{
		float t = time * (.5) + (((.2 * sin(time)) + .8) * 2.);
	
		uPos.y += sin( uPos.x*(i+2.0) + sin(t*.1)*i/5.0 ) * (sin(time * 0.1) * sin(time * 0.03) * 0.6);
		float fTemp = abs(1.2 / uPos.y / 50.0);
		vertColor += fTemp;
		color += vec3( fTemp, fTemp * 5., pow(fTemp,0.9999)*1.0 );
	}
	
	vec4 color_final = vec4(color, 0);
	
	vec2 uv = gl_FragCoord.xy / resolution.xy;
	vec4 s = vec4(0.0);
	float o = 0.1;
	s += texture2D(tex, uv + vec2( -o, -o));
	s += texture2D(tex, uv + vec2(10.0, -o));
	s += texture2D(tex, uv + vec2(  o, -o));
	s += texture2D(tex, uv + vec2( -o, 10.0));
	s += texture2D(tex, uv + vec2(10.0, 10.0));
	s += texture2D(tex, uv + vec2(  o, 10.0));
	s += texture2D(tex, uv + vec2( -o,  o));
	s += texture2D(tex, uv + vec2(10.0,  o));
	s += texture2D(tex, uv + vec2(  o,  o));
	s /= 90.0;
	
	color_final = mix( color_final, s, sin(p.x*p.y/ + time*8.0) * 0.25 + 0.75 );	
	
	float avg = color_final.r + color_final.g + color_final.b;
	avg /= 1.0;
	color_final = vec4(vec3(0.7 * (sin(time * 0.0013) * .5 + .5), 0.63 * (sin(time * 0.17) * .5 + .5), 0.91 * (sin(time * 0.3) * .5 + .5)) * avg, 1.0);
	
	gl_FragColor = color_final;

}