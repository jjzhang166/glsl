// ref:
// http://blog.hvidtfeldts.net/index.php/2011/11/distance-estimated-3d-fractals-vi-the-mandelbox/


#ifdef GL_ES
precision mediump float;
#endif

uniform float time;
uniform vec2 mouse;
uniform vec2 resolution;




void sphereFold(inout vec3 z, inout float dz)
{
    const float fixedRadius2 = 1.0;
    const float minRadius2 = 0.5;
    float r2 = dot(z,z);
    if (r2<minRadius2) { 
        // linear inner scaling
        float temp = (fixedRadius2/minRadius2);
        z *= temp;
        dz*= temp;
    } else if (r2<fixedRadius2) { 
        // this is the actual sphere inversion
        float temp =(fixedRadius2/r2);
        z *= temp;
        dz*= temp;
    }
}
void boxFold(inout vec3 z, inout float dz)
{
    const float foldingLimit = 2.0;
    z = clamp(z, -foldingLimit, foldingLimit) * 2.0 - z;
}
float map(vec3 z)
{
	z.y = z.y + time*0.1;
	z = mod(z, 8.5) -4.25;

    float Scale = -2.7;
    vec3 offset = z;
    float dr = 1.0;
    for(int n = 0; n<16; n++) {
        boxFold(z,dr);
        sphereFold(z,dr);
        z = Scale*z + offset;
        dr = dr*abs(Scale)+14.0;
    }
    float r = length(z);
    return r/abs(dr);
}

void main( void ) {
	
	vec2 pos = (gl_FragCoord.xy*2.0 - resolution.xy) / resolution.y;
	vec3 camPos = vec3(6.9, 0.0, 6.7);
	vec3 camDir = normalize(vec3(0.0, -0.2, -1.0));
	
	
    float sr = sin(time*0.05);
    float cr = cos(time*0.05);
    mat3 rotz = mat3(
        cr, sr, 0,
        sr,-cr, 0,
         0,  0, 1 );
    mat3 roty = mat3(
      cr, 0, sr,
       0, 1,  0,
     -sr, 0, cr );
	camDir = normalize(roty * vec3(0.0, -0.2, -1.0));
	vec3 camUp  = normalize(vec3(0.0, 1.0, 0.0));
	vec3 camSide = cross(camDir, camUp);
	float focus = 1.8;
	
	vec3 rayDir = normalize(camSide*pos.x + camUp*pos.y + camDir*focus);
	vec3 ray = camPos;
	float m = 0.0;
	float d = 0.0, total_d = 0.0;
	const int MAX_MARCH = 64;
	const float MAX_DISTANCE = 1000.0;
	for(int i=0; i<MAX_MARCH; ++i) {
		d = map(ray);
		total_d += d;
		ray += rayDir * d;
		m += 1.0;
		if(d<0.001) { break; }
		if(total_d>MAX_DISTANCE) { break; }
	}
	
	
	float r = mod(time*2.0, 20.0);
	float glow = max((mod((ray.x+ray.y+ray.z)-time*2.0, 15.0)-13.0)/2.0, 0.0);
	vec3 gp = abs(mod(ray, vec3(1.2)));
	if(gp.x<1.175 && gp.z<1.175) {
		glow = 0.0;
	}	
	
	float c = (total_d)*0.05;
	vec4 result = vec4( vec3(c, c, c*2.0) + vec3(0.01, 0.01, 0.02)*m*0.1, 1.0 );
	result.xyz += vec3(glow*1.0, glow*1.0, glow*2.5);
	gl_FragColor = result;
}
	