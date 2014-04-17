#ifdef GL_ES
precision mediump float;
#endif

uniform float time;
uniform vec2 mouse;
uniform vec2 resolution;

float iSphere(vec3 ro, vec3 rd)
{
	float t = 1000.0;
	float r = 0.4;	// Radius
	
	// |P|^2 = r^2
	// (O + tD)^2 = r^2
	// (O + tD)^2 - r^2 = 0
	// O^2 + tD^2 + 2tOD - r^2 = 0
	// tD^2 + 2tOD + O^2 - r^2 = 0
	// a = D^2
	// b = 2OD
	// c = O^2 - r^2
	
	float a = dot(rd, rd);
	float b = 2.0 * dot(ro, rd);
	float c = dot(ro, ro) - r * r;
	
	float det = b * b - 4.0 * a * c;
	
	if(det < 0.0) t = 1000.0;	// No possible roots.
	else
	{
		float t0 = (-b + sqrt(det)) / (2.0 * a);
		float t1 = (-b - sqrt(det)) / (2.0 * a);
		
		if(t0 <= t1) t = t0;
		else t = t1;
	}
	
	return t;
}

float iPlane(vec3 ro, vec3 rd)
{
	float t = 1000.0;
	
	// O + tD = 0.0
	// tD = -O
	// t = -O / D;
	
	t = -ro.y / rd.y;
	if(t > 1.0) t = 1000.0;
	
	return t;
}

vec3 trace(vec3 ro, vec3 rd)
{
	vec3 col = vec3(0.1);
	float t = 1000.0;
	
	float tsph = iSphere(ro, rd);
	if(tsph < t)
	{
		t = tsph;
		col = vec3((t - 0.5) * 1.4);
		col.g *= 1.1;
	}
	
	float tpla = iPlane(ro, rd);
	if(tpla < t)
	{
		t = tpla;
		col = vec3(t * 0.4);
	}
	
	return col;
}

void main()
{
	vec2 pix = -1.0 + 2.0 * gl_FragCoord.xy / resolution.xy;
	pix.x *= resolution.x / resolution.y;
	
	vec3 ro = vec3(sin(time), 3.0 + cos(time), -10.0);
	vec3 rd = normalize(vec3(pix, 1.0)) - ro;
	
	vec3 col = trace(ro, rd);	
	gl_FragColor = vec4(col, 1.0);
}