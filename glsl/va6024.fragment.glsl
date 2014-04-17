// ref:
// http://blog.hvidtfeldts.net/index.php/2011/11/distance-estimated-3d-fractals-vi-the-mandelbox/


#ifdef GL_ES
precision mediump float;
#endif

uniform float time;
uniform vec2 mouse;
uniform vec2 resolution;

const int iters = 16;
const float MR2 = .5;
const int MAX_MARCH = 64;
const float MAX_DISTANCE = 1000.0;

float SCALE = -3.0 + sin(time/7.)*1.0;
//const float SCALE = -3.0;
	
vec4 scalevec = vec4(SCALE, SCALE, SCALE, abs(SCALE)) / MR2;
float C1 = abs(SCALE-1.0);
float C2 = pow(abs(SCALE), float(1-iters));


float DE(vec3 position)
{
	vec4 p = vec4(position.xyz, 1.0);
	vec4 p0 = p;  // p.w is knighty's DEfactor
	for (int i = 0; i < iters; i++)
	{
		p.xyz = clamp(p.xyz, -1.0, 1.0) * 2.0 - p.xyz;  // box fold: min3, max3, mad3
		float r2 = dot(p.xyz, p.xyz);  // dp3
		p.xyzw *= clamp(max(MR2/r2, MR2), 0.0, 1.0);  // sphere fold: div1, max1.sat, mul4
		p.xyzw = p*scalevec + p0;  // mad4
	}
	return (length(p.xyz) - C1) / p.w - C2;
}

void main( void )
{
	vec2 pos = (gl_FragCoord.xy*2.0 - resolution.xy) / resolution.y;
	const vec3 camAt = vec3(0., 0., 0.);
	const vec3 camUp  = vec3(0.0, 1.0, 0.0);
	vec3 camPos = vec3(6.*sin(time /30.), 0.0, 6.*cos(time / 30.));
	vec3 camDir = normalize (camAt - camPos);
	vec3 camSide = cross(camDir, camUp);
	const float focus = 2.8;
	
	vec3 rayDir = normalize(camSide*pos.x + camUp*pos.y + camDir*focus);
	int m = 0;
	float total_d = 0.0;
	for(int i=0; i<MAX_MARCH; ++i)
	{
		vec3 ray = camPos + rayDir * total_d;
		float d = DE(ray);
		total_d += d;
		m ++;
		if(d<0.001)
			break;
		if(total_d>MAX_DISTANCE)
			break;
	}
	
	float c = (total_d)*0.02;
	gl_FragColor = vec4( vec3(c, c, c*2.0) + vec3(0.01, 0.01, 0.02)*float(m), 1.0 );

}