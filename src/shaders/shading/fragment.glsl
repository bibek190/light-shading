uniform vec3 uColor;

varying vec3 vNormal;
varying vec3 vPosition;


#include ../includes/ambientLight.glsl;

vec3 directionalLight(vec3 lightColor,float lightIntensity,vec3 normal,vec3 lightPosition,vec3 viewDirection){
    
    vec3 lightDirection = normalize(lightPosition);
    vec3 lightReflection = reflect(-lightDirection,normal);
    
    // shading 
    float shading = dot(normal,lightDirection);
    shading = max(0.0,shading);

    // Specular 
    float specular = dot(lightReflection,viewDirection);
    specular = pow(specular,20.0);


    // return lightColor * lightIntensity * shading;
    return vec3(specular);
}


void main()
{
    vec3 viewDirection = normalize(vPosition - cameraPosition);
    vec3 color = uColor;

    // Light 
    vec3 light = vec3(0.0);
    light += ambientLight(
        vec3(1.0),    //LightColor
        0.03         //LightIntensity
        );

    // directionalLight
light += directionalLight(
    vec3(0.1,0.1,1.0),      //lightColor
    1.0,             //light intensity
    vNormal,         // normal
    vec3(0.0,0.0,3.0),      //light position
    viewDirection
    );

    color *= light;

    // Final color
    gl_FragColor = vec4(color, 1.0);
    #include <tonemapping_fragment>
    #include <colorspace_fragment>
}