import json


class KKSsystem:
    def __init__(self):
        with open("KKS_equipment.json", mode="r") as fp:
            self.KKS = json.load(fp)

    def find(self, substr: str) -> dict[str, str]:
        """find
        Searches the KKS equipment description for instances of *substr*
        Parameters
        ----------
        substr : str
            text to search for in KKS equipment

        Returns
        -------
        dict[str, str]
            Dict containing equipment description that contains the *substr*
        """
        substr = substr.lower()
        return {k: v for k, v in self.KKS["Equipment"].items() if substr in v.lower()}

    def valid_equipment(self) -> dict[str, str]:
        """valid_equipment
        Shows only the valid KKS equipment numbers

        Returns
        -------
        dict[str, str]
            Dict with all "-blocked-" values removed
        """
        return {k: v for k, v in self.KKS["Equipment"].items() if "-blocked-" not in v.lower()}

    def interpret(self, kks_number: str):
        pass
