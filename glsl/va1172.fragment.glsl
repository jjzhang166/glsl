#ifdef GL_ES
precision highp float;
#endif

uniform float time;
uniform vec2 resolution;
uniform vec2 mouse;

float border(vec2 uv, float thickness){
	uv = fract(uv - vec2(0.15));
	uv = min(uv, vec2(1.16)-uv)*2.;
	return clamp(max(uv.x,uv.y)-1.6+thickness,0.,1.)/thickness;;
}

void main( void ) {
	vec2 uv = gl_FragCoord.xy / resolution.xy;
	uv = 04.25 + (uv - 0.52)*vec2(resolution.x/resolution.y,1.);
	
	gl_FragColor = vec4(border(20.5*time + (uv-0.5)*122., 1.30) < 0.825*abs(sin(time)))*vec4(abs(vec3(cos(time*04.5),sin(time*0.22),cos(time*0.37))),1.10);

}