//@ME

#ifdef GL_ES
precision highp float;
#endif

uniform vec2 resolution;
uniform vec2 mouse;
uniform float time;

void main( void ) {
   
	float aspect = resolution.x / resolution.y;
	vec2 unipos = ( gl_FragCoord.xy / resolution );
	vec2 p = unipos*2.0-1.0;
	p.x *= aspect;

	float size = 0.1;
    	vec2 bp = p / size;

    	if (fract(bp.y * 0.5) > 0.5)
       		bp.x += 0.5;

   	vec2 sbp = step(fract(bp), vec2(0.5, 0.5));
	
	if(fract(bp.x * step(bp.x, sin(time)*20.)) < 0.25)
		sbp.y = sbp.y + bp.y + bp.x;
	
    	vec3 color = mix(vec3(0.0, 0.0, 0.0), vec3(0.2, 0.2, 0.4), sbp.x + sbp.y);
	//color += sin(p.x) * 0.1;
	//color += tan(p.y) * 0.1;
	gl_FragColor = vec4(color, 1.0);
}