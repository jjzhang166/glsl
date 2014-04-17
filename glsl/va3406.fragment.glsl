#ifdef GL_ES
precision mediump float;
#endif

uniform float time;
uniform vec2 mouse;
uniform vec2 resolution;

float aspect = resolution.x / resolution.y;
vec2 unipos = ( gl_FragCoord.xy / resolution );
vec2 pos = vec2( (unipos.x*2.0-1.0)*aspect, unipos.y*2.0-1.0);

void main( void ) {

	vec2 size = vec2(0.25, 0.1);
    	vec2 bp = pos / size;

    	if (fract(bp.y * 0.25) > 0.75)
       		bp.x += 0.25;

   	vec2 sbp = step(fract(bp), vec2(0.5, 0.5));
    	vec3 color  = mix(vec3(0.0, 0.0, 0.0), vec3(1.0, 0.0, 0.0), clamp(sbp.x + sbp.y, 0.0, 2.0)*.5);
	gl_FragColor = vec4(color, 1.0);
}