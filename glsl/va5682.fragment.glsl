#ifdef GL_ES
precision mediump float;
#endif

uniform float time;
uniform vec2 mouse;
uniform vec2 resolution;

#define shadowColor vec3(0.3,0.4,0.5)*0.25
#define blue vec3(0.0,0.0,0.9)
#define groundColor vec3(0.8,0.9,1.0)
#define red vec3(1.0,0.1,0.1)
#define skyColor vec3(0.9,1.0,1.0)*2.0
#define greenColor vec3(0.0, 0.7, 0.0)
#define viewMatrix mat4(0.0)
#define fovyCoefficient 10.0
#define shadowHardness 2.0

#define epsilon 0.001
#define PI 3.1415926535897932384626433832795028841971693993751058

// materials
#define SKY_MTL 0
#define GROUND_MTL 1
#define BUILDINGS_MTL 2
#define RED_MTL 3
#define GREEN_MTL 4

float sdPlane( vec3 p, vec4 n ){ return dot(p,n.xyz) + n.w; }

float sdBox( vec3 p, vec3 b ) {
  vec3 d = abs(p) - b;
  return min(max(d.x,max(d.y,d.z)),0.0) + length(max(d,0.0));
}

float sdSphere( vec3 p, float s ) { return length(p)-s; }

vec3 MaterialColor( int mtl ) {
	if(mtl==SKY_MTL) return skyColor;
	if(mtl==BUILDINGS_MTL) return blue;//(0.5 + 0.5*sin(time*0.5))*vec3(1.0) + buildingsColor*(1.0-(0.5 + 0.5*sin(time*0.5)));;
	if(mtl==GROUND_MTL) return groundColor;
	if(mtl==RED_MTL) return red;
	if(mtl==GREEN_MTL) return greenColor;

    return vec3(1.0,0.0,1.0); // means error
}

bool aoLerp = false;
vec3 avgColor = vec3(0.);

float scene(in vec3 p, out int mtl ){

	float floor = sdPlane(p, vec4(0., 1., 0., 0.));

	float closest = floor;
    mtl = GROUND_MTL;

	vec3 box_p = vec3(-2., 1.5, -1.);
    float box = sdBox(p - box_p, vec3(0.5, 1.5, 1.0));
	float power = 0.5;
	float weight = 1.0;
	float killWeight = 1.0;
	float topClamp = 1.;

	if ( box < closest ) {
        closest = box;
        mtl = BUILDINGS_MTL;
		if (aoLerp) avgColor += weight*MaterialColor(BUILDINGS_MTL)/max(pow(box,power),topClamp);
    } else if (aoLerp) avgColor += killWeight*MaterialColor(BUILDINGS_MTL)/max(pow(box,power),topClamp);

	vec3 box2_p = vec3(0.0, 1.0, 0.0);
	float box2 = sdBox(p - box2_p, vec3(0.2, 0.75, 0.75));

	if ( box2 < closest ) {
        closest = box2;
        mtl = GROUND_MTL;
		if (aoLerp) avgColor += weight*MaterialColor(GROUND_MTL)/max(pow(box2,power),topClamp);
    } else if (aoLerp) avgColor += killWeight*MaterialColor(GROUND_MTL)/max(pow(box2,power),topClamp);

	vec3 leftWall_p = vec3(-3.6, 2.25, -0.4);
	float leftWall = sdBox(p - leftWall_p, vec3(0.1, 2.25, 2.0));

	if ( leftWall < closest ) {
        closest = leftWall;
        mtl = RED_MTL;
		if (aoLerp) avgColor += weight*MaterialColor(RED_MTL)/max(pow(leftWall,power),topClamp);
    } else if (aoLerp) avgColor += killWeight*MaterialColor(RED_MTL)/max(pow(leftWall,power),topClamp);

	vec3 rightWall_p = vec3(2.0 + 0.4*(sin(time*1.23)), 2.25, -0.4);
	float rightWall = sdBox(p - rightWall_p, vec3(0.1, 2.25, 2.0));

	if ( rightWall < closest ) {
        closest = rightWall;
        mtl = GREEN_MTL;
		if (aoLerp) avgColor += weight*MaterialColor(GREEN_MTL)/max(pow(rightWall,power),topClamp);
    } else if (aoLerp) avgColor += killWeight*MaterialColor(GREEN_MTL)/max(pow(rightWall,power),topClamp);

	vec3 backWall_p = vec3(-0.6, 2.25, -2.5);
	float backWall = sdBox(p - backWall_p, vec3(3.0, 2.25, 0.1));

	if ( backWall < closest ) {
        closest = backWall;
        mtl = GROUND_MTL;
		if (aoLerp) avgColor += weight*MaterialColor(GROUND_MTL)/max(pow(backWall,power),topClamp);
    } else if (aoLerp) avgColor += killWeight*MaterialColor(GROUND_MTL)/max(pow(backWall,power),topClamp);

	vec4 sphere_p = vec4(-1.5*sin(time) - 1.0, 1.0*cos(time*0.9) + 1.0, cos(time*1.1), 1.);
	float sphere = sdSphere(p - sphere_p.xyz, sphere_p.w);
	
    if ( sphere < closest ) {
        closest = sphere;
		mtl = RED_MTL;
		if (aoLerp) avgColor += weight*MaterialColor(RED_MTL)/max(pow(sphere,power),topClamp);
    } else if (aoLerp) avgColor += killWeight*MaterialColor(RED_MTL)/max(pow(sphere,power),topClamp);

	avgColor = clamp(normalize(avgColor)-0.5,0.0,1.0);
    return closest;
}


float Softshadow( in vec3 landPoint, in vec3 lightVector){
    float penumbraFactor = 1.0;
    vec3 sphereNormal;
    float t = 0.001;
    for( int s = 0; s < 32; ++s ){
	int dummy;
        float nextDist = scene(landPoint + lightVector*t, dummy);

        if( nextDist < 0.01 ) return 0.0;
	    
        penumbraFactor = min( penumbraFactor, shadowHardness * nextDist / t );
        t += nextDist;
    }
    return penumbraFactor;
}

vec3 intersect(in vec3 ro, in vec3 rd, out int mtl) {
    float h, t = 1.0;

    for (int i = 0; i < 128; ++i) {
        h = scene(t*rd + ro,mtl);
	if ( h < 0.01) return t*rd + ro;
	t += h;
    }
    return t*rd + ro;
}

vec3 ComputeNormal(vec3 p, int material) {
    int dummy;
    return normalize(
        vec3(
          scene( vec3(p.x + epsilon, p.y, p.z), dummy ) - scene( vec3(p.x - epsilon, p.y, p.z), dummy )
        , scene( vec3(p.x, p.y + epsilon, p.z), dummy ) - scene( vec3(p.x, p.y - epsilon, p.z), dummy )
        , scene( vec3(p.x, p.y, p.z + epsilon), dummy ) - scene( vec3(p.x, p.y, p.z - epsilon), dummy )
        )
    );
}

float ambientOcclusion(vec3 p, vec3 n, float stepDistance, float samples) {
    float ao = 0., dist;
	int dummy;
    for (float i = 1.; i <= 10.; i++) {
        dist = stepDistance * i;
        ao += (dist - scene(p + n * dist,dummy)) / (i * i);
    }
    return ao;
}

vec3 globalIllumination(vec3 p, vec3 n, float stepDistance) {
	vec3 g = vec3(0.0);
	float dist;
	int dummy;
	aoLerp = true;
	for (float i = 1.; i <= 2.; i++) {
		dist = stepDistance * i;
		scene(p + n * dist,dummy);
		g += avgColor/(pow(i,0.3));
		//g = avgColor;
		avgColor = vec3(0.);
	}
	aoLerp = false;
	return g;
}

vec3 render() {
    vec2 p = -1.0 + 2.0 * gl_FragCoord.xy / resolution;
    vec2 screenPos = (gl_FragCoord.xy/resolution - vec2(0.5)) * vec2(PI,PI/(resolution.x / resolution.y))/2.0;
    vec3 direction = normalize(vec3( screenPos.x , screenPos.y + 0.5*(mouse.y - 1.) , -1.5)),
	 pos = vec3(3.5*(mouse.x - 0.5), 3.5, 10.);
	
    int material;
    vec3 hitPosition = intersect(pos, direction, material);

    vec3 color;

	vec3 lightpos = vec3(1.0, 8.0, 10.0 );
        vec3 lightVector = normalize(lightpos - hitPosition);
        float shadow = Softshadow(hitPosition, lightVector);
        vec3 normal = ComputeNormal(hitPosition, material);
        float attenuation = clamp(dot(normal, lightVector),0.0,1.0)*0.6 + 0.4;
        shadow = min(shadow, attenuation);
	    
        vec3 mtlColor = MaterialColor(material);
        color = mix(shadowColor, mtlColor, 0.4+shadow*0.6);
	    
        vec3 hitNormal = ComputeNormal(hitPosition, 0);
        float AO = 1.0-0.65*ambientOcclusion(hitPosition, hitNormal, 0.2, 5.0);
        color = mix(shadowColor*mtlColor, color, 1.0)*AO;
        
	if (sin(time*2.) < 10.) {
		vec3 GI = clamp(globalIllumination(hitPosition, hitNormal, 0.1),0.0,1.0);
			//return GI; // to view GI output
		//return vec3(shadow);
		color *= 0.8;
		color += GI;
	}
	
	return color;
}

void main( void ) {
	gl_FragColor = vec4(render(),1.);
}