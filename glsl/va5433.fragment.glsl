// 00f404afdd835ac3af3602c8943738ea -- pls leave this line intact
// noise play -- looking for a 'fast-enough' (or interesting) noise function

#ifdef GL_ES
precision highp float;
#endif

uniform float time;
uniform vec2 mouse;
uniform vec2 resolution;

float fnoise(vec3 p) { return fract(length(cross(p,vec3(0.9)))) * 2. - 1.;  }
float sphere(vec3 position, float radius) { return length(position)-radius; }
float scene(vec3 position) { return sphere(position,0.25); }

void main(void) {
	vec2 eye = (gl_FragCoord.xy / resolution.xy) * 2. - 1.;
	eye.x *= resolution.x / resolution.y;
	
	vec3 origin = vec3(0., 0., -1.);
	vec3 direction = normalize(vec3(eye,1.)-origin);
	
	vec4 color = vec4(1.);
	
        vec3 p = origin + direction;
	color = vec4(vec3(fnoise(time*p)),1.0);
        gl_FragColor = color;

}