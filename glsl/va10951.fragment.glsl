#ifdef GL_ES
precision mediump float;
#endif
// dashxdr was here 20130301
// http://www.xdr.com/dash/blog/index.php?entry=entry121018-015739
// Want to show a sphere with squares tiling it
// work in progress, just a red sphere with some lighting
// horizontal stripes sliding down...
// spiral going down. Wow that's cool...
// got rid of unexpected lines in background... Fatter stripes
// tweak in lighting direction
// got some tilting action going... damned seam ruins it...
// ahhh. That's what I was after. Got rid of the spiral though...oh well.
// Got rid of seam at 12:00
// Added SCALE tunable, squares 2x bigger
// dashxdr forked off own shader...Boing!
// bouncing up and down...
// bouncing side to side, direction reverses...
// fixed floor...

uniform float time;
uniform vec2 mouse;
uniform vec2 resolution;

void main( void ) {

#define RADIUS .2
	float h = .2 * ( 1.0*resolution.y/resolution.x - pow(2.0 * fract(time*.4) - 1.0, 2.0));
	float xpos = fract(time*.11);
	if(xpos > .5) xpos = 1.0 - xpos;
	
	xpos = RADIUS + 3.0 * xpos * (1.0 - RADIUS * 2.0);
	vec2 center = resolution * vec2(xpos, RADIUS + h);

	vec2 position = ( (gl_FragCoord.xy - center) / resolution.xx );

#define SCALE (5.0929581*0.5)
	position *= (1.0 / RADIUS);
	float r = length(position);
	vec3 color = vec3(1.0, 0.0, 0.0);
	float spec = 0.0;
	float diffuse = 0.0;
	if(r <= 1.0)
	{
		float z = sqrt(1.0 - r*r);
		vec3 norm = vec3(position, z);
		vec3 fix = norm;
		float tilt = -0.2;
		vec2 mat = vec2(cos(tilt), cos(tilt));
		fix.x = dot(norm.xy, mat);
		fix.y = dot(norm.xy, vec2(-mat.y, mat.x));
		float lat = asin(fix.y);
		float lon = atan(fix.x, fix.z)+xpos*10.0;
		float y = SCALE * log(1.0 / cos(lat) + tan(lat));
		float x = lon * SCALE;
		float t = fract(y);
		if(fract(x) < .5) t = 1.0 - t;
		if(t < .5) color.g = color.b = .9;
		vec3 lightpos = normalize(vec3(-1.0, 1.0, 0.5));
		diffuse = dot(norm, lightpos);
		diffuse = max(diffuse, 0.0) + .2;
		vec3 halfdir = normalize(lightpos + vec3(0.0, 0.0, 1.0));
		spec = dot(halfdir, norm);
		spec = pow(max(spec, 0.0), 60.0);
	}

	gl_FragColor = vec4( color*diffuse + vec3(1.0, 1.0, 1.0)*spec, 1.0 );

}