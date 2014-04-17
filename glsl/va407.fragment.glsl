#ifdef GL_ES
precision highp float;
#endif

uniform float time;
uniform vec2 mouse;
uniform vec2 resolution;
uniform sampler2D backbuffer;

#define HalfOverPI 0.159154943091895

void main( void ) {
	vec2 position = ( gl_FragCoord.xy / resolution.xy );
	vec2 pixel = 1./resolution;
	vec4 me = texture2D(backbuffer, position);

	vec2 pos2 = vec2(gl_FragCoord) - (resolution * 0.5);
	float theta = atan(pos2.y, pos2.x) * HalfOverPI + 0.5;
	float dist = theta - mod(time * 0.1, 1.0);
	float sweep = mod(time * 0.1, 1.0);
	float lastsweep = mod(time * 0.1 - 0.4, 1.0);
	if (sweep < lastsweep) {
		lastsweep -= 1.0;
		if (theta > sweep) {theta -= 1.0;}
	}
	//float sweepStrength = pow(max(0.0, (theta - lastsweep) / (sweep - lastsweep)), 10.0);
	//if (sweepStrength > 1.0) { sweepStrength = 0.0; }
	
	if ((theta <= sweep) && (theta > lastsweep)) {
		float wouldBeTime = time + ((theta - sweep) * 10.0);
		float radius = length(pos2) / min(resolution.x, resolution.y);
		vec2 place = floor(vec2((10.0 / (radius + 0.5)) + wouldBeTime, wouldBeTime * 1.5) * 3.0);
		float rnd1 = mod(fract(56.0*sin(dot(place, vec2(14.9898,78.233))) * 43758.5453), 1.0);
		float rnd2 = mod(fract(37.0*sin(dot(place, vec2(14.9898,78.233))) * 43758.5453), 1.0);
		float rnd3 = mod(fract(42.0*sin(dot(place, vec2(14.9898,78.233))) * 43758.5453), 1.0);
		me.rgb = vec3(rnd1, rnd2, rnd3);
	} else {
		me -= 0.004;
	}

	//gl_FragColor = vec4(0, sweepStrength, 0.0, 1.0);
	gl_FragColor = vec4(me.rgb, 1.0);
}