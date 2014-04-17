#ifdef GL_ES
precision mediump float;
#endif
 
uniform float time;
uniform vec2 resolution;

 
vec2 getPos() {
        return (gl_FragCoord.xy*2.0 - resolution.xy) / resolution.y;
}

const float hardness = 4.;
float smin(float a, float b){
	return a+b-log(exp(a*hardness)+exp(b*hardness))/hardness;	
}

float march(in vec3 p){
	        vec3 sintime = vec3(sin(time)*.3, cos(time)*.4, sin(time)*.5),
	             sintime2 = vec3(sin(-time*.2)*.6, sin(time*.5)*.3, -cos(time*.3)*.3);
	        float objects[6], displacement = sin(15.*p.x)*sin(15.*p.y)*sin(15.*p.z)*.1;
		objects[0] = length(p+sintime)-.1;
		objects[1] = length(p+dot(sintime2.yyx,vec3(0.,0.,1.)))-displacement-.1;
		objects[2] = length(p-dot(-sintime2,vec3(-1.,1.,1.)))-displacement-.1;
		objects[3] = length(p+cross(sintime2,vec3(-1.,1.,1.)))-displacement-.1;
		objects[4] = length(p-cross(sintime2,sintime))-displacement-.2;
		//objects[5] = length(vec2(length(p.xz+sintime.yy)-.2,p.y+sintime.x))-.05;
	     
		float plane  = dot(p,vec3(0,-10.,-8.)) + 10.;
	        float plane2 = dot(p,vec3(0,10.,-8.))  + 10.;
	        float plane3 = dot(p,vec3(0.,0.,2.))   + 3.;
		float minplane = min(plane,min(plane2,plane3));
	
                return smin(minplane,
			smin(
				smin(
					smin(objects[0],objects[1]),
					smin(objects[2],objects[3])
				),
				smin(objects[4],10.)
			) );

} 

const int maxIterations = 70;
const float maxDistance = 10000.,
            minDistance = 0.01;

void main( void ){
	
    vec2 pos       = getPos()*.2;
    vec3 camera    = vec3(0.,0.,1.0),
         direction = normalize(camera),
         ray       = camera;

    vec3 cameraNormal = normalize(cross(direction, vec3(0.,1.,0.))); //(0,1,0) is up
    direction = normalize(cameraNormal*pos.x + vec3(0.,1.,0.)*pos.y - camera*.2);              

    float dist  = 0.,
                  total = dist,
                  color, p;

    int iterations = 0;

    for(int i = 0; i < maxIterations; i++){
                ++iterations;
                dist = march(ray);                   
                ray += dist * direction;
                total += dist;              
                if(dist < minDistance) break;
                if(dist > maxDistance) break;
    }
               
    color = 1. - (.0001 * (total>maxDistance?maxDistance:total));
    p = float(iterations)/float(maxIterations);
    gl_FragColor = vec4(color*0.9,color,pow(color,10.)*1.1,1.)- vec4(p,p,p,1.) * 3.;
}