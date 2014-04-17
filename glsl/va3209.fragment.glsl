//@ME

#ifdef GL_ES
precision lowp float;
#endif

uniform vec2 resolution;
uniform vec2 mouse;

void main( void ) {
   
	vec2 p = gl_FragCoord.xy / resolution;
	float size = 0.1;
    	vec2 bp = p / size * mouse.y;

    	if (fract(bp.y * 0.5) > 0.5)
       		bp.x += 0.5;

   	vec2 sbp = step(fract(bp), vec2(0.5, 0.5));
    	vec3 color  = mix(vec3(0.0, 0.0, 0.0), vec3(0.5, 0.8, 0.4), sbp.x + sbp.y);
	gl_FragColor = vec4(color, 1.0);
}