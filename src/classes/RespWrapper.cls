global class RespWrapper {

    public String id;
    public Boolean success;
    public String message;

    public RespWrapper(String id, Boolean success, String message) {
        this.id = id;
        this.success = success;
        this.message = message;
    }

}