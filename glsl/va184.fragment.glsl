
// from http://frank.bitsnbites.eu/safe.html

#ifdef GL_ES
precision highp float;
#endif

uniform sampler2D tex0;
uniform vec2 pixel;
uniform float time;
uniform vec2 mouse;
uniform vec2 resolution;

void main() {
	// retrieve the texture coordinate
	vec2 c = ( gl_FragCoord.xy  );

	// and the current pixel
	vec3 current = texture2D(tex0, c).rgb;

	// count the neightbouring pixels with a value greater than zero
	vec3 neighbours = vec3(0.0);
	neighbours += vec3(greaterThan(texture2D(tex0, c + pixel*vec2(-1,-1)).rgb, vec3(0.0)));
	neighbours += vec3(greaterThan(texture2D(tex0, c + pixel*vec2(-1, 0)).rgb, vec3(0.0)));
	neighbours += vec3(greaterThan(texture2D(tex0, c + pixel*vec2(-1, 1)).rgb, vec3(0.0)));
	neighbours += vec3(greaterThan(texture2D(tex0, c + pixel*vec2( 0,-1)).rgb, vec3(0.0)));
	neighbours += vec3(greaterThan(texture2D(tex0, c + pixel*vec2( 0, 1)).rgb, vec3(0.0)));
	neighbours += vec3(greaterThan(texture2D(tex0, c + pixel*vec2( 1,-1)).rgb, vec3(0.0)));
	neighbours += vec3(greaterThan(texture2D(tex0, c + pixel*vec2( 1, 0)).rgb, vec3(0.0)));
	neighbours += vec3(greaterThan(texture2D(tex0, c + pixel*vec2( 1, 1)).rgb, vec3(0.0)));

	// check if the current pixel is alive
	vec3 live = vec3(greaterThan(current, vec3(0.0)));

	// resurect if we are not live, and have 3 live neighrbours
	current += (1.0-live) * vec3(equal(neighbours, vec3(3.0)));

	// kill if we do not have either 3 or 2 neighbours
	current *= vec3(equal(neighbours, vec3(2.0))) + vec3(equal(neighbours, vec3(3.0)));

	// fade the current pixel as it ages
	current -= vec3(greaterThan(current, vec3(0.4)))*0.05;

	// write out the pixel
	gl_FragColor = vec4(current, 1.0);
}