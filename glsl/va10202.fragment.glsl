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

float march(vec3 p){
		float ballA = length(p+vec3(sin(time)/1.7,-cos(time/2.)/2.3,cos(time/2.)/3.+.1))-.2+sin(time/2.)*.02;
	        float ballB = length(p-vec3(sin(time)/1.7,cos(time/2.)/1.3,cos(time/2.)/3.+.1))-.2+sin(time/2.)*.1;
		float ballC = length(p+vec3(sin(time+1000.)*0.9,cos(time+10./2.)/3.,-cos(time/2.)/3.+.1))-.2+sin(time+1./1.5)*.01;
                return smin(ballA, smin(ballB, ballC))-.1;

} 

const int maxIterations = 70;
const float maxDistance = 10000.,
            minDistance = 0.01;

void main( void ){
	
    vec2 pos       = getPos()*.2;
    vec3 camera    = vec3(sin(time/1.),cos(time/1.),4.0),
                direction = normalize(-camera),
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
    gl_FragColor = vec4(color,color,color,1.)- vec4(p,p,p,1.) * 3.;
}