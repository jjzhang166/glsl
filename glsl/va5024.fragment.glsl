#ifdef GL_ES
precision highp float;
#endif

//CITIRAL WAS HERE
//JUST DOING THIS FOR BEER

uniform float time;
uniform vec2 mouse;
uniform vec2 resolution;
const int passes = 64;

float rand(vec2 co){
    return fract(sin(dot(co.xy ,vec2(12.9898,78.233))) * 43758.5453);
}

float pingpong(float val, float maxval)
{
	float rest = mod(val,maxval);
	float times = floor(val/maxval);
	if (mod(times,2.) == 0.) {
		return rest;
	}
	else {
		return maxval - rest;
	}
}

float sdSphere( vec3 p, float s )
{
  return clamp(length(p)-s,-1.,0.);
}

vec4 scene(vec3 p, int i)
{
	vec4 col = vec4(0,0,0,0);
	col.x -= sign(sdSphere( vec3(gl_FragCoord.x - resolution.x/2. + p.x, gl_FragCoord.y - resolution.y/2. - p.y, i) , 60.)) * (1./float(passes));
	//col.x -= sign(sdSphere( vec3(gl_FragCoord.y - resolution.y/2. + p.x, gl_FragCoord.x - resolution.x/2. - p.y, i) , (abs(sin(time)))*60.)) * (1./float(passes));
	col.x += sign(sdSphere( vec3(gl_FragCoord.x - resolution.x/2. - 50. + p.x, gl_FragCoord.y - resolution.y/2. - 50. + p.y, i) , 60.)) * (1./float(passes));
	col.x += sign(sdSphere( vec3(gl_FragCoord.x - resolution.x/2. + 50. + p.x, gl_FragCoord.y - resolution.y/2. - 50. + p.y, i) , 60.)) * (1./float(passes));
	col.x += sign(sdSphere( vec3(gl_FragCoord.x - resolution.x/2. + 50. + p.x, gl_FragCoord.y - resolution.y/2. + 50. + p.y, i) , 60.)) * (1./float(passes));
	col.x += sign(sdSphere( vec3(gl_FragCoord.x - resolution.x/2. - 50. + p.x, gl_FragCoord.y - resolution.y/2. + 50. + p.y, i) , 60.)) * (1./float(passes));
	return col;
}

void main( void ) {
	vec4 col = vec4(0,0,0,0);
	for (int i = 0 ; i < passes ; i++) {
		col += scene(
			vec3(
				rand(vec2(time,time))*0., //RANDOM X DISPLACEMENT 
				sin(time)*110., //Y WARP
				0.), //NOTHING
			i); // PASS
	}
	
	gl_FragColor = col;

}

