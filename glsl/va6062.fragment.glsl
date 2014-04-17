
#ifdef GL_ES
precision mediump float;
#endif

uniform float time;
uniform vec2 mouse;
uniform vec2 resolution;



void sphereFold(inout vec3 z, inout mat3 dz)
{
    const float fixedRadius2 = 1.9;
    const float minRadius2 = 1.2;
	float r2 = dot(z,z);
	if (r2 < minRadius2) {
		float temp = (fixedRadius2/minRadius2);
		z*= temp; dz*=temp;
	} else if (r2<fixedRadius2) {
		float temp =(fixedRadius2/r2);
                dz[0] =temp*(dz[0]-z*2.0*dot(z,dz[0])/r2);
                dz[1] =temp*(dz[1]-z*2.0*dot(z,dz[1])/r2);
                dz[2] =temp*(dz[2]-z*2.0*dot(z,dz[2])/r2);
		z*=temp; dz*=temp;
	}
}

// reverse signs for dual vectors when folding
void boxFold(inout vec3 z, inout mat3 dz)
{
    const float foldingLimit = 1.0;
    if (abs(z.x)>foldingLimit) { dz[0].x*=-1.0; dz[1].x*=-1.0; dz[2].x*=-1.0; }
    if (abs(z.y)>foldingLimit)  { dz[0].y*=-1.0; dz[1].y*=-1.0; dz[2].y*=-1.0; }
    if (abs(z.z)>foldingLimit)  { dz[0].z*=-1.0; dz[1].z*=-1.0; dz[2].z*=-1.0; }
    z = clamp(z, -foldingLimit, foldingLimit) * 2.0 - z;
}

float map(vec3 z)
{
    const int Iterations = 16;
    const float Scale = 2.0;
    vec3 Offset = vec3(1.0);
	mat3 dz = mat3(1.0,0.0,0.0,0.0,1.0,0.0,0.0,0.0,1.0);
	
	vec3 c = z;
	mat3 dc = dz;
	for (int n = 0; n < Iterations; n++) {
		boxFold(z,dz);
		sphereFold(z,dz);
		z*=Scale;
		dz=mat3(dz[0]*Scale,dz[1]*Scale,dz[2]*Scale);
		z += c*Offset;
	        dz +=matrixCompMult(mat3(Offset,Offset,Offset),dc);
		if (length(z)>1000.0) break;
	}
	return dot(z,z)/length(z*dz); 
}


void main( void )
{
    vec2 pos = (gl_FragCoord.xy*2.0 - resolution.xy) / resolution.y;
    vec3 camPos = vec3(7.0+cos(time*0.3), 6.0+sin(time*0.3), 10.0);
    vec3 camTarget = vec3(0.0, 0.0, 0.0);

    vec3 camDir = normalize(camTarget-camPos);
    vec3 camUp  = normalize(vec3(0.0, 1.0, 0.0));
    vec3 camSide = cross(camDir, camUp);
    float focus = 1.8;

    vec3 rayDir = normalize(camSide*pos.x + camUp*pos.y + camDir*focus);
    vec3 ray = camPos;
    float m = 0.0;
    float d = 0.0, total_d = 0.0;
    const int MAX_MARCH = 50;
    const float MAX_DISTANCE = 1000.0;
    for(int i=0; i<MAX_MARCH; ++i) {
        d = map(ray);
        total_d += d;
        ray += rayDir * d;
        m += 1.0;
        if(d<0.001) { break; }
        if(total_d>MAX_DISTANCE) { total_d=MAX_DISTANCE; break; }
    }

    float c = (total_d)*0.0001;
    vec4 result = vec4( 1.0-vec3(c, c, c) - vec3(0.025, 0.025, 0.02)*m*0.8, 1.0 );
    gl_FragColor = result;
}
