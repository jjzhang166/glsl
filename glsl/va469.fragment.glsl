#ifdef GL_ES
precision lowp float;
#endif
uniform float time;
uniform vec4 mouse;
uniform vec2 resolution;
const int nrOfPoints = 50;
float points[nrOfPoints];
void sortPoints(){
        for(int i = 0; i < nrOfPoints; i++){
                for(int j = 0; j < nrOfPoints - 1; j++){
                        if(points[j] > points[j+1]){
                                float temp = points[j];
                                points[j+1] = points[j];
                                points[j] = temp;
                        }
                }
        }
}
void main( void ) {
        
        //float frame = 1463.0;
        float frame = (time*0.001);
        for(int i = 0; i < nrOfPoints; i++){
                //calculate
                points[i] =
                        distance(
                        resolution.xy/2.0 + sin(0.2*frame *vec2(i+1,2*i+1))*resolution.xy/2.0, 
                        gl_FragCoord.xy );
        }
        //sortPoints();
        float c = float( points[25]/points[24] > points[20]/points[19] );
        
        gl_FragColor = vec4(c, c, c, 1.0);
}