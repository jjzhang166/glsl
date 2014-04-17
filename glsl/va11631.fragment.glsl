#ifdef GL_ES
precision mediump float;
#endif

uniform vec2 resolution;
uniform float time;
void main( void ) {
	
	vec2 pos = ( (2.*( gl_FragCoord.xy / resolution.xy) ) - 1.0); // position of our pixel, with vec2(0.0, 0.0) centred
	pos.x *= resolution.x / resolution.y; // correct for aspect ratio, e.g. 1024/768
	float len = distance(vec2(sin(time),cos(time*2.)), pos * 1.5); 
	//float len = distance(vec2(.0,.0), pos * 1.5); 

        vec3 col = vec3(0.1); // 
	float rad = .7;
	if (len < rad) { col.rgb = mix( col,vec3(0.4,1.0,0.0) , .3+ 45.* (rad-len)); }
	
	if (pos.x < 0.0) { col.rgb *= 0.75; } 
	if (pos.y > 0.0) { col.r *= 2.5; }
	
	if (gl_FragCoord.x/resolution.x >.5) { col.rgb += vec3(.3,.3,sin(time)); }
        
	float rnd = fract(sin(.121416623/sin(time))); 
	
	//if (fract(pos.x * 10. * rnd) <.2) { col.rgb = mix ( col, vec3(1.,1.,1.), rnd); }
	
	
	gl_FragColor = vec4(col, 1.0); // return the colour

}